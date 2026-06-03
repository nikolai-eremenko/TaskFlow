//
//  ErrorMapperAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Swinject

final class ErrorMapperAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ErrorMapping.self) { _ in
            CoreErrorMapper()
        }
    }
}
