//
//  CoreErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class CoreErrorMapper: ErrorMapper {

    // MARK: - Private Properties

    private let mappers: [ErrorMapper]

    // MARK: - Initializers

    init(mappers: [ErrorMapper]) {
        self.mappers = mappers
    }

    // MARK: - Public Methods

    func canMap(_ error: Error) -> Bool {
        error is CoreError
    }

    func map(_ error: Error) -> DomainError {
        guard let coreError = error as? CoreError else { return .common(.unknown)}

        let underlying: Error

        switch coreError {
        case .networkService(let error):
            underlying = error
        }

        return mapUnderlying(underlying)
    }

    // MARK: - Private Methods

    private func mapUnderlying(_ error: Error) -> DomainError {
        for mapper in mappers where mapper.canMap(error) {
            return mapper.map(error)
        }

        return .common(.unknown)
    }
}
