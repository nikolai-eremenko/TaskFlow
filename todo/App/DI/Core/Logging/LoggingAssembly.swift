//
//  LoggingAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

final class LoggingAssembly: Assembly {

    func assemble(container: Container) {

        container.register(AppLogger.self) { resolver in

            let env = resolver.resolve(AppEnvironment.self)!
            let config = env.configuration

            let loggers = config.loggerFactories.map {
                $0.make(resolver: resolver)
            }

            return CompositeLogger(
                loggers,
                minLevel: config.logLevel,
                appInfo: resolver.resolve(AppInfo.self)!
            )
        }
        .inObjectScope(.container)
    }
}
