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
    ) async throws(CoreError) -> T {

        do {
            let result = try await stack.performBackgroundTask {
                try block($0)
            }

            logger.debug("Successfully completed background task", category: .persistence, traceId: traceId)

            return result

        } catch {
            let coreError = mapError(error)
            logger.logError(coreError, category: .persistence, traceId: traceId)

            throw coreError
        }
    }

    func performViewTask<T>(
        traceId: UUID,
        _ block: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async throws(CoreError) -> T {

        let context = stack.viewContext

        do {
            let result = try await context.perform {
                try block(context)
            }

            logger.debug("Successfully completed view task", category: .persistence, traceId: traceId)

            return result

        } catch {
            let coreError = mapError(error)
            logger.logError(coreError, category: .persistence, traceId: traceId)
            throw coreError
        }
    }

    func viewContext() -> NSManagedObjectContext {
        stack.viewContext
    }

    // MARK: - Private methods

    private func mapError(_ error: Error) -> CoreError {
        if let coreDataError = error as? CoreDataStorageError {
            return CoreError.persistence(coreDataError)
        }

        let nsError = error as NSError

        switch nsError.domain {
        case NSCocoaErrorDomain:
            switch nsError.code {
            case NSManagedObjectValidationError:
                return CoreError.persistence(.saveFailed)
            case NSManagedObjectConstraintMergeError:
                return CoreError.persistence(.saveFailed)
            default:
                return CoreError.persistence(.contextExecutionFailed)
            }

        default:
            return CoreError.persistence(.contextExecutionFailed)
        }
    }
}
