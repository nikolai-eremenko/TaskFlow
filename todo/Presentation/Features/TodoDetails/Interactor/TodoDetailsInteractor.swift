//
//  TodoDetailsInteractor.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Foundation

final class TodoDetailsInteractor {

    weak var output: TodoDetailsInteractorOutput?

    private let repository: TodoRepository
//    private let errorMapper: ErrorMapping
    private let logger: AppLogger

    private var currentTodo: Todo?

    init(
        repository: TodoRepository,
//        errorMapper: ErrorMapping,
        logger: AppLogger
    ) {
        self.repository = repository
//        self.errorMapper = errorMapper
        self.logger = logger
    }

}

// MARK: - TodoDetailsInteractorInput

extension TodoDetailsInteractor: TodoDetailsInteractorInput {

    func loadTodo(id: UUID, traceId: UUID) async {
        do {
            guard let todo = try await repository.fetch(id: id, traceId: UUID()) else {
                let output = self.output
                output?.didFail(DomainError.common(.unknown))
                return
            }

            currentTodo = todo

            let output = self.output
            output?.didLoad(todo: todo)

        } catch {
            let output = self.output
//            let domainError = errorMapper.map(error)

            logger.logError(error, category: .feature, traceId: traceId)
            output?.didFail(error)
        }
    }

    func saveTodo(title: String, description: String?, traceId: UUID) async {

        do {
            let todo: Todo

            if let existing = currentTodo {
                todo = Todo(
                    id: existing.id,
                    serverId: existing.serverId,
                    title: title,
                    taskDescription: description,
                    createdAt: existing.createdAt,
                    isCompleted: existing.isCompleted
                )

                try await repository.update(todo: todo, traceId: traceId)

            } else {
                todo = Todo(
                    id: UUID(),
                    serverId: nil,
                    title: title,
                    taskDescription: description,
                    createdAt: Date(),
                    isCompleted: false
                )

                try await repository.create(todo: todo, traceId: traceId)
            }

        } catch {
            let output = self.output
//            let domainError = errorMapper.map(error)

            output?.didFail(error)
        }
    }
}
