//
//  CoreAssemblies.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

enum CoreAssemblies {

    private static var assemblies: [Assembly] {
        [
            LoggingAssembly(),
            AppInfoAssembly(),
            ErrorMapperAssembly(),
            AppEnvironmentAssembly(environment: AppEnvironment.fromPlist())
        ]
    }

    static func all() -> [Assembly] {
        assemblies
    }
}
