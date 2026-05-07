//
//  DataErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class DataErrorMapper: ErrorMapper {

    // MARK: - Private Properties

    private let mappers: [ErrorMapper]

    // MARK: - Initializers

    init(mappers: [ErrorMapper]) {
        self.mappers = mappers
    }

    // MARK: - Public Methods

    func canMap(_ error: Error) -> Bool {
        error is DataError
    }

    func map(_ error: Error) -> DomainError {
        guard let dataError = error as? DataError else { return .common(.unknown) }

        let underlying: Error

        switch dataError {

        case .persistence(let error):
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
