//
//  DataError.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

enum DataError: Error {
    case persistence(CoreDataStorageError)
}

extension DataError: LogLevelProvider {
    var logLevel: LogLevel {
        switch self {
        case .persistence(let error):
            return error.logLevel
        }
    }
}
