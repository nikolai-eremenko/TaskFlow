//
//  AppInfoAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

final class AppInfoAssembly: Assembly {

    func assemble(container: Container) {
        container.register(AppInfo.self) { _ in
            AppInfoProvider()
        }
        .inObjectScope(.container)
    }
}
