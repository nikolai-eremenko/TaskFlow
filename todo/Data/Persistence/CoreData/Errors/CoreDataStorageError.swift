//
//  CoreDataStorageError.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

enum CoreDataStorageError: Error {
    case saveFailed
    case fetchFailed
    case contextExecutionFailed
    case storeLoadFailed
    case notFound
}

extension CoreDataStorageError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {

        case .saveFailed, .fetchFailed, .contextExecutionFailed, .notFound:
            return .error

        case .storeLoadFailed:
            return .critical
        }
    }
}
