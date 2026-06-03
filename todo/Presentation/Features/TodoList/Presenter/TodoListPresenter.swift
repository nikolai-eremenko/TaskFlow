//
//  TodoListPresenter.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import UIKit

final class TodoListPresenter {

    // MARK: - Private properties

    weak var view: TodoListViewInput?
    var interactor: TodoListInteractorInput
    var router: TodoListRouterInput

    private let logger: AppLogger

    private var searchTask: Task<Void, Never>?
    private var todos: [Todo] = []

    // MARK: - Init

    init(
        interactor: TodoListInteractorInput,
        router: TodoListRouterInput,
        logger: AppLogger
    ) {
        self.interactor = interactor
        self.router = router
        self.logger = logger
    }
}

// MARK: - Interactor Output

extension TodoListPresenter: TodoListInteractorOutput {

    func didReceiveChange(_ change: TodoChange) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            switch change {

            case .reload(let newTodos):
                self.todos = newTodos

                let items = self.todos.map(TodoCellViewModel.init)
                self.view?.render(change: .reload(items), todosCount: todos.count)

            case .update(let updatedTodo):
                if let item = self.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                    todos[item] = updatedTodo
                }

                let model = TodoCellViewModel(todo: updatedTodo)

                self.view?.render(change: .update(model), todosCount: todos.count)
            }
        }
    }

    func didFail(_ error: DomainError) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            self.view?.showError(message: error.localizedDescription)
        }
    }

    func didReceiveVoiceText(_ text: String) {
        Task { @MainActor in
            view?.updateSearchText(text)

            // reuse existing pipeline
            didSearch(text: text)
        }
    }

    func didStartVoiceInput() {
        Task { @MainActor in
            view?.setVoiceInputState(.recording)
        }
    }

    func didStopVoiceInput() {
        Task { @MainActor in
            view?.setVoiceInputState(.idle)
        }
    }

    func didFailVoiceInput(_ error: DomainError) {
        Task { @MainActor in
            view?.showError(message: error.localizedDescription)
            view?.setVoiceInputState(.idle)
        }
    }
}

// MARK: - View Output

extension TodoListPresenter: TodoListViewOutput {

    func viewDidLoad(traceId: UUID) {
        logger.debug("Start todo list flow setup", category: .feature, traceId: traceId)

        interactor.start(traceId: traceId)

        Task {
            await interactor.loadInitialData(traceId: traceId)
        }
    }

    func didTapCheckbox(id: UUID) {
        let traceId = UUID()

        logger.debug("Toggle todo flow started", category: .userInterface, traceId: traceId)

        Task {
            await interactor.toggleCompletion(id: id, traceId: traceId)
        }
    }

    func didSelectEdit(id: UUID) {
        let traceId = UUID()

        logger.debug("Edit todo flow started", category: .userInterface, traceId: traceId)
        router.openEditTodo(id: id, traceId: traceId)
    }

    func didSelectShare(id: UUID) {
        let traceId = UUID()

        logger.debug("Share todo flow started", category: .userInterface, traceId: traceId)

        guard let todo = todos.first(where: { $0.id == id }) else { return }

        let shareItem = TodoShareItem(title: todo.title, description: todo.taskDescription, deepLink: nil)

        router.shareTodo(item: shareItem, traceId: traceId)
    }

    func didSelectDelete(id: UUID, traceId: UUID) {
        logger.debug("Delete todo flow started", category: .feature, traceId: traceId)

        Task {
            await interactor.deleteTodo(id: id, traceId: traceId)
        }
    }

    func didSearch(text: String) {
        let traceId = UUID()

        logger.debug("Search todo flow started", category: .userInterface, traceId: traceId)

        searchTask?.cancel()

        searchTask = Task { [weak self] in
            guard let self else { return }

            try? await Task.sleep(nanoseconds: 500_000_000)

            guard !Task.isCancelled else { return }

            await self.interactor.searchTodos(text: text, traceId: traceId)
        }
    }

    func didTapCreate(traceId: UUID) {
        logger.debug("Create todo flow started", category: .userInterface, traceId: traceId)
        router.openCreateTodo(traceId: traceId)
    }

    func didTapVoiceSearch(_ traceId: UUID) {
        let languageCode = Locale.preferredLanguages.first ?? "en-US"

        var metadata = LogMetadataBuilder()
        metadata.reason(languageCode)

        logger.debug("Voice search started", category: .feature, metadata: metadata.build(), traceId: traceId)

        interactor.startVoiceInput(languageCode: languageCode, traceId)
    }
}
