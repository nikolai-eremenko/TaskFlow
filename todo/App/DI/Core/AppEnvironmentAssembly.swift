//
//  AppEnvironmentAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

struct AppEnvironmentAssembly: Assembly {

    private let environment: AppEnvironment

    // MARK: - Init

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    func assemble(container: Container) {

        container.register(AppEnvironment.self) { _ in
            self.environment
        }
        .inObjectScope(.container)
    }
}
