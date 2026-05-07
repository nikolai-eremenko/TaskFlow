//
//  CompositeErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class CompositeErrorMapper: ErrorMapper {

    // MARK: - Private Properties

    private let mappers: [ErrorMapper]

    // MARK: - Init

    /// Creates an error mapper with a collection of service-specific mappers.
    ///
    /// - Parameter serviceMappers: Ordered list of mappers used to resolve errors.
    /// The first mapper that returns `true` from `canMap(_:)` will handle the error.
    init(serviceMappers: [ErrorMapper]) {
        self.mappers = serviceMappers
    }

    // MARK: - Public Methods

    func canMap(_ error: any Error) -> Bool {
        true
    }

    /// Delegates error mapping to the first matching service mapper.
    ///
    /// - Parameter error: The incoming error.
    /// - Returns: A mapped `DomainError`, or `.common(.unknown)` if no mapper matches.
    func map(_ error: Error) -> DomainError {
        for mapper in mappers where mapper.canMap(error) {
            return mapper.map(error)
        }

        return .common(.unknown)
    }
}
