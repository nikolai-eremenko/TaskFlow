//
//  PersistenceAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Swinject

final class PersistenceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CoreDataStack.self) {
            let logger = $0.resolve(AppLogger.self)!

            do {
                return try CoreDataStack(modelName: "AppPersistence")

            } catch {
                logger.logError(error, category: .persistence)
                fatalError("CoreDataStack initialization failed: \(error)")
            }

        }
        .inObjectScope(.container)

        container.register(CoreDataStorage.self) {

            DefaultCoreDataStorage(
                stack: $0.resolve(CoreDataStack.self)!,
                logger: $0.resolve(AppLogger.self)!
            )

        }
        .inObjectScope(.container)

        container.register(SettingsStorage.self) {
            DefaultSettingsStorage(
                logger: $0.resolve(AppLogger.self)!
            )
        }
        .inObjectScope(.container)
    }
}
