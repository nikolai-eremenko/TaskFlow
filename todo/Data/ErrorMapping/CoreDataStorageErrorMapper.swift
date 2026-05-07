//
//  CoreDataStorageErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class CoreDataStorageErrorMapper: ErrorMapper {

    func canMap(_ error: Error) -> Bool {
        error is CoreDataStorageError
    }

    func map(_ error: Error) -> DomainError {
        guard let storageError = error as? CoreDataStorageError else { return .common(.unknown) }

        switch storageError {
        case .saveFailed:                   return .storage(.failure)
        case .fetchFailed:                  return .storage(.failure)
        case .contextExecutionFailed:       return .storage(.failure)
        case .storeLoadFailed:              return .storage(.unavailable)
        case .notFound:                     return .storage(.failure)
        }
    }
}
