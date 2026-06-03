//
//  DefaultTodoRepository.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation

final class DefaultTodoRepository: TodoRepository {

    // MARK: - Private properties

    private let api: TodoRemoteService
    private let storage: TodoStorage
    private let settingsStorage: SettingsStorage
    private let errorMapper: ErrorMapping
    private let logger: AppLogger

    // MARK: - Init

    init(
        api: TodoRemoteService,
        storage: TodoStorage,
        settingsStorage: SettingsStorage,
        errorMapper: ErrorMapping,
        logger: AppLogger
    ) {
        self.api = api
        self.storage = storage
        self.settingsStorage = settingsStorage
        self.errorMapper = errorMapper
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

    func bootstrapIfNeeded(traceId: UUID) async throws(DomainError) {
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

        do {
            let response = try await api.fetchTodos(traceId: traceId)
            let todos = response.toDomain()

            logger.debug("Saving initial data", category: .persistence, traceId: traceId)
            try await storage.upsert(todos, traceId: traceId)

            logger.debug("Marking initial remote load as completed", category: .persistence, traceId: traceId)
            settingsStorage.save(true, for: .hasLoadedRemote, traceId: traceId)
        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }
    }

    func fetch(id: UUID, traceId: UUID) async throws(DomainError) -> Todo? {
        do {
            return try await storage.fetch(id: id, traceId: traceId)

        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }
    }

    func create(todo: Todo, traceId: UUID) async throws(DomainError) {
        do {
            try await storage.upsert([todo], traceId: traceId)

        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }
    }

    func update(todo: Todo, traceId: UUID) async throws(DomainError) {
        do {
            try await storage.upsert([todo], traceId: traceId)

        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }

    }

    func delete(id: UUID, traceId: UUID) async throws(DomainError) {
        do {
            try await storage.delete(id: id, traceId: traceId)

        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }
    }

    func toggleTodoCompletion(id: UUID, traceId: UUID) async throws(DomainError) {

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
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .persistence, traceId: traceId)
            throw domainError
        }
    }

    func search(text: String, traceId: UUID)/* async throws(CoreError)*/ {
        storage.updateSearch(text: text)
    }
}
