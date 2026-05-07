//
//  DefaultTodoStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData
import Foundation

final class DefaultTodoStorage: TodoStorage {

    // MARK: - Private properties

    private let storage: CoreDataStorage
    private let logger: AppLogger
    private var observer: TodoChangeObserver?

    // MARK: - init

    init(
        storage: CoreDataStorage,
        logger: AppLogger
    ) {
        self.storage = storage
        self.logger = logger
    }

    // MARK: - Public methods

    func upsert(_ todos: [Todo], traceId: UUID) async throws {
        var metadata = LogMetadataBuilder()
        metadata.count(todos.count)

        logger.debug(
            "Upsert todos",
            category: .persistence,
            metadata: metadata.build(),
            traceId: traceId
        )

        try await storage.performBackgroundTask(
            traceId: traceId
        ) { context in
            let ids = todos.map(\.id)
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

            request.predicate = NSPredicate(format: "id IN %@", ids)
            request.returnsObjectsAsFaults = false
            request.includesPropertyValues = true

            let existingEntities = try context.fetch(request)

            var entityMap = Dictionary(uniqueKeysWithValues: existingEntities.map { ($0.id, $0) })

            entityMap.reserveCapacity(todos.count)

            for todo in todos {
                let entity = entityMap[todo.id] ?? TodoEntity(context: context)

                entity.update(from: todo)
            }
        }
    }

    func fetch(id: UUID, traceId: UUID) async throws -> Todo? {
        logger.debug("Fetching todo", category: .persistence, traceId: traceId)

        return try await storage.performViewTask(traceId: traceId) { context in
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            return try context.fetch(request).first.map(Todo.init)
        }
    }

    func delete(id: UUID, traceId: UUID) async throws {

        logger.debug("Deleting todo", category: .persistence, traceId: traceId)

        try await storage.performBackgroundTask(traceId: traceId) { context in

            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            guard let entity = try context.fetch(request).first else {
                let dataError = DataError.persistence(.notFound)
                self.logger.logError(dataError, category: .persistence, traceId: traceId)
                throw dataError
            }

            context.delete(entity)
            try context.save()
        }
    }

    func updateSearch(text: String) {
        observer?.updateSearch(text: text)
    }

    func observeChanges() -> AsyncStream<TodoChange> {
        AsyncStream { continuation in
            let observer = TodoChangeObserver(context: storage.viewContext())

            self.observer = observer

            observer.onChange = { change in
                continuation.yield(change)
            }

            observer.start()

            continuation.onTermination = { _ in
                self.observer = nil
            }
        }
    }
}
