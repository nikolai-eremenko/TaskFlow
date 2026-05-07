//
//  DataAssemblies.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Swinject

enum DataAssemblies {

    private static var assemblies: [Assembly] {
        [
            NetworkAssembly(),
            PersistenceAssembly(),
            RepositoryAssembly()
        ]
    }

    static func all(
        oAuthProviderAssemblies: [Assembly] = []
    ) -> [Assembly] {
        assemblies
    }
}
