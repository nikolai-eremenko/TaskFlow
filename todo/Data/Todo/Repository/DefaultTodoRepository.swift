//
//  DefaultTodoRepository.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation

final class DefaultTodoRepository: TodoRepository {

    // MARK: - Private properties

    private let api: TodoAPIService
    private let storage: TodoStorage
    private let settingsStorage: SettingsStorage
    private let logger: AppLogger

    // MARK: - Init

    init(
        api: TodoAPIService,
        storage: TodoStorage,
        settingsStorage: SettingsStorage,
        logger: AppLogger
    ) {
        self.api = api
        self.storage = storage
        self.settingsStorage = settingsStorage
        self.logger = logger
    }

    // MARK: - Public Methods

    func observe(traceId: UUID) -> AsyncStream<TodoChange> {
        AsyncStream { continuation in

            let stream = storage.observeChanges()

            let task = Task(priority: .utility) {
                for await change in stream {
                    continuation.yield(change)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    func bootstrapIfNeeded(traceId: UUID) async throws {
        logger.debug(
            "Checking if initial remote load is needed",
            category: .persistence,
            traceId: traceId
        )

        let hasLoaded = settingsStorage.load(for: .hasLoadedRemote, traceId: traceId) ?? false

        guard !hasLoaded else {
            logger.debug(
                "Initial remote load skipped — already completed",
                category: .persistence,
                traceId: traceId
            )
            return
        }

        logger.debug("Loading initial remote data", category: .persistence, traceId: traceId)
        let response = try await api.fetchTodos(traceId: traceId)
        let todos = response.toDomain()

        logger.debug("Saving initial data", category: .persistence, traceId: traceId)
        try await storage.upsert(todos, traceId: traceId)

        logger.debug("Marking initial remote load as completed", category: .persistence, traceId: traceId)
        settingsStorage.save(true, for: .hasLoadedRemote, traceId: traceId)
    }

    func fetch(id: UUID, traceId: UUID) async throws -> Todo? {
        do {
            return try await storage.fetch(id: id, traceId: traceId)

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)
            throw error
        }
    }

    func create(todo: Todo, traceId: UUID) async throws {
        logger.debug("Creating todo", category: .persistence, traceId: traceId)

        do {
            try await storage.upsert([todo], traceId: traceId)

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)
            throw error
        }
    }

    func update(todo: Todo, traceId: UUID) async throws {
        do {
            try await storage.upsert([todo], traceId: traceId)

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)
            throw error
        }
    }

    func delete(id: UUID, traceId: UUID) async throws {
        do {
            try await storage.delete(id: id, traceId: traceId)

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)
            throw error
        }
    }

    func toggleTodoCompletion(id: UUID, traceId: UUID) async throws {

        do {
            if let todo = try await storage.fetch(id: id, traceId: traceId) {
                let updated = Todo(
                    id: todo.id,
                    serverId: todo.serverId,
                    title: todo.title,
                    taskDescription: todo.taskDescription,
                    createdAt: todo.createdAt,
                    isCompleted: !todo.isCompleted
                )

                try await storage.upsert([updated], traceId: traceId)
            }

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)
            throw error
        }
    }

    func search(text: String, traceId: UUID) async throws {
        storage.updateSearch(text: text)
    }
}
