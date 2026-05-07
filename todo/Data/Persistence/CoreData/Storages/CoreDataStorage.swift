//
//  CoreDataStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData

protocol CoreDataStorage {

    func performBackgroundTask<T>(
        traceId: UUID,
        _ block: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T

    func performViewTask<T>(
        traceId: UUID,
        _ block: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T

    func viewContext() -> NSManagedObjectContext
}
