//
//  DefaultCoreDataStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData

final class DefaultCoreDataStorage: CoreDataStorage {

    // MARK: - Private properties

    private let stack: CoreDataStack
    private let logger: AppLogger

    // MARK: - Init

    init(
        stack: CoreDataStack,
        logger: AppLogger
    ) {
        self.stack = stack
        self.logger = logger
    }

    // MARK: - Public methods

    func performBackgroundTask<T>(
        traceId: UUID,
        _ block: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T {

        do {
            let result = try await stack.performBackgroundTask {
                try block($0)
            }

            logger.debug("Successfully completed background task", category: .persistence, traceId: traceId)

            return result

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)

            throw DataError.persistence(mapError(error))
        }
    }

    func performViewTask<T>(
        traceId: UUID,
        _ block: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T {

        let context = stack.viewContext

        do {
            let result = try await context.perform {
                try block(context)
            }

            logger.debug("Successfully completed view task", category: .persistence, traceId: traceId)

            return result

        } catch {
            logger.logError(error, category: .persistence, traceId: traceId)

            throw DataError.persistence(mapError(error))
        }
    }

    func viewContext() -> NSManagedObjectContext {
        stack.viewContext
    }

    // MARK: - Private methods

    private func mapError(_ error: Error) -> CoreDataStorageError {

        if let coreDataError = error as? CoreDataStorageError {
            return coreDataError
        }

        let nsError = error as NSError

        switch nsError.domain {
        case NSCocoaErrorDomain:
            switch nsError.code {
            case NSManagedObjectValidationError:
                return .saveFailed
            case NSManagedObjectConstraintMergeError:
                return .saveFailed
            default:
                return .contextExecutionFailed
            }

        default:
            return .contextExecutionFailed
        }
    }
}
