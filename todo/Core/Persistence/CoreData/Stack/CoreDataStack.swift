//
//  CoreDataStack.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData

final class CoreDataStack {

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private let container: NSPersistentContainer

    // MARK: - Init

    init(modelName: String, inMemory: Bool = false) throws {
        container = NSPersistentContainer(name: modelName)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.url = URL(fileURLWithPath: "/dev/null")

            container.persistentStoreDescriptions = [description]
        }

        var resultError: Error?

        let semaphore = DispatchSemaphore(value: 0)

        container.loadPersistentStores { _, error in
            resultError = error
            semaphore.signal()
        }

        semaphore.wait()

        if let error = resultError {
            throw error
        }

        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil
        context.shouldDeleteInaccessibleFaults = true
    }

    // MARK: - Public methods

    func performBackgroundTask<T>(
        _ block: @escaping @Sendable (NSManagedObjectContext) throws -> T
    ) async throws -> T {

        try await withCheckedThrowingContinuation { continuation in

            container.performBackgroundTask { context in

                do {
                    let result = try block(context)

                    if context.hasChanges {
                        try context.save()
                    }

                    continuation.resume(returning: result)

                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
