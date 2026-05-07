//
//  TaskListInteractor.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Foundation

final class TodoListInteractor {

    var output: TodoListInteractorOutput?

    private var observingTask: Task<Void, Never>?

    private let repository: TodoRepository
    private let logger: AppLogger
    private let errorMapper: ErrorMapper

    // MARK: - Init

    init(
        repository: TodoRepository,
        logger: AppLogger,
        errorMapper: ErrorMapper
    ) {
        self.repository = repository
        self.logger = logger
        self.errorMapper = errorMapper
    }
}

extension TodoListInteractor: TodoListInteractorInput {

    func start(traceId: UUID) {
        logger.debug("Start observing todos changes", category: .feature, traceId: traceId)

        observingTask?.cancel()

        observingTask = Task { [weak self] in
            guard let self else { return }

            for await change in repository.observe(traceId: traceId) {
                await MainActor.run {
                    self.output?.didReceiveChange(change)
                }
            }
        }
    }

    func loadInitialData(traceId: UUID) async {
        logger.debug("Start initial bootstrap", category: .feature, traceId: traceId)

        do {
            try await repository.bootstrapIfNeeded(traceId: traceId)

            logger.debug(
                "Initial bootstrap completed",
                category: .feature,
                traceId: traceId
            )

        } catch {
            logger.logError(error, category: .feature, traceId: traceId)

            await MainActor.run {
                output?.didFail(errorMapper.map(error))
            }
        }
    }

    func deleteTodo(id: UUID, traceId: UUID) async {
        logger.debug("Delete todo", category: .feature, traceId: traceId)

        do {
            try await repository.delete(id: id, traceId: traceId)

        } catch {
            await MainActor.run {
                output?.didFail(errorMapper.map(error))
            }
        }
    }

    func toggleCompletion(id: UUID, traceId: UUID) async {

        do {
            try await repository.toggleTodoCompletion(id: id, traceId: traceId)

            logger.debug(
                "Toggle todo completion finished successfully",
                category: .feature,
                traceId: traceId
            )

        } catch {
            await MainActor.run {
                output?.didFail(errorMapper.map(error))
            }
        }
    }

    func searchTodos(text: String, traceId: UUID) async {
        logger.debug("Searching todos", category: .feature, traceId: traceId)

        do {
            try await repository.search(text: text, traceId: traceId)

        } catch {
            await MainActor.run {
                output?.didFail(errorMapper.map(error))
            }
        }
    }
}
