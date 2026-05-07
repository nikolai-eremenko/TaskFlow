//
//  ErrorMapperAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Swinject

final class ErrorMapperAssembly: Assembly {

    func assemble(container: Container) {

        container.register(ErrorMapper.self, name: "network") { _ in
            NetworkErrorMapper()
        }

        container.register(ErrorMapper.self, name: "coreData") { _ in
            CoreDataStorageErrorMapper()
        }

        container.register(ErrorMapper.self, name: "dataError") {
            let dataMappers: [ErrorMapper] = [
                $0.resolve(ErrorMapper.self, name: "coreData")!
            ]

            return DataErrorMapper(mappers: dataMappers)
        }

        container.register(ErrorMapper.self, name: "coreError") {
            let coreMappers: [ErrorMapper] = [
                $0.resolve(ErrorMapper.self, name: "network")!

            ]

            return CoreErrorMapper(mappers: coreMappers)
        }

        // MARK: - Root ErrorMapper

        container.register(ErrorMapper.self) {
            let core = $0.resolve(ErrorMapper.self, name: "coreError")!
            let data = $0.resolve(ErrorMapper.self, name: "dataError")!

            return CompositeErrorMapper(serviceMappers: [core, data])
        }
    }
}
