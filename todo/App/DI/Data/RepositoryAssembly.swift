//
//  RepositoryAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Swinject

final class RepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(TodoStorage.self) {
            DefaultTodoStorage(
                storage: $0.resolve(CoreDataStorage.self)!,
                logger: $0.resolve(AppLogger.self)!
            )
        }
        .inObjectScope(.container)

        container.register(TodoAPIService.self) { resolver in
            DefaultTodoAPIService(
                network: resolver.resolve(NetworkService.self)!,
                logger: resolver.resolve(AppLogger.self)!
            )
        }

        container.register(TodoRepository.self) { resolver in
            DefaultTodoRepository(
                api: resolver.resolve(TodoAPIService.self)!,
                storage: resolver.resolve(TodoStorage.self)!,
                settingsStorage: resolver.resolve(SettingsStorage.self)!,
                logger: resolver.resolve(AppLogger.self)!
            )
        }
    }
}
