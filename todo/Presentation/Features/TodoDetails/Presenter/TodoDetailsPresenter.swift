//
//  TodoDetailsPresenter.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Foundation

final class TodoDetailsPresenter {

    weak var view: TodoDetailsViewInput?
    var interactor: TodoDetailsInteractorInput?
    var router: TodoDetailsRouting?

    private let input: TodoDetailsInput
    private let logger: AppLogger

    private var originalTitle: String = ""
    private var originalDescription: String?
    private var isEditMode: Bool {
        if case .edit = input.mode { return true }
        return false
    }

    // MARK: - Init

    init(
        input: TodoDetailsInput,
        logger: AppLogger
    ) {
        self.input = input
        self.logger = logger
    }
}

// MARK: - View Output

extension TodoDetailsPresenter: TodoDetailsViewOutput {

    func didChange(title: String, description: String?) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        let isTitleValid = !trimmedTitle.isEmpty

        if isEditMode {
            let hasChanges =
            trimmedTitle != originalTitle ||
            (description ?? "") != (originalDescription ?? "")

            view?.setSaveEnabled(isTitleValid && hasChanges)

        } else {
            view?.setSaveEnabled(isTitleValid)
        }
    }

    func didTapSave(title: String, description: String?) {
        let traceId = UUID()

        logger.debug("Saving todo flow started", category: .userInterface, traceId: traceId)

        Task { [weak self] in
            guard let self else { return }

            await self.interactor?.saveTodo(title: title, description: description, traceId: traceId)

            await MainActor.run {
                self.router?.close()
            }
        }
    }

    func viewDidLoad() {
        switch input.mode {

        case .create:
            originalTitle = ""
            originalDescription = nil

            view?.displayCreateState()
            view?.setSaveEnabled(false)

        case .edit(let id):
            let traceId = UUID()

            logger.debug("Editing todo flow started", category: .userInterface, traceId: traceId)

            Task { [weak self] in
                guard let self else { return }

                await self.interactor?.loadTodo(id: id, traceId: traceId)
            }
        }
    }
}

// MARK: - Interactor Output

extension TodoDetailsPresenter: TodoDetailsInteractorOutput {

    func didFail(_ error: DomainError) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            self.view?.showError(message: error.localizedDescription)
        }
    }

    func didLoad(todo: Todo) {

        Task { @MainActor [weak self] in
            guard let self else { return }

            self.originalTitle = todo.title
            self.originalDescription = todo.taskDescription

            self.view?.display(todo: todo)
            self.view?.setSaveEnabled(false)
        }
    }
}
