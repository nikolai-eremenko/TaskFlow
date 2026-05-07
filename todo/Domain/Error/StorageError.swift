//
//  StorageError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum StorageError: Error {

    /// Generic storage failure
    case failure

    /// Database corrupted or migration failed
    case corruptedData

    /// Store unavailable (cannot be loaded)
    case unavailable
}

extension StorageError: LogLevelProvider {
    var logLevel: LogLevel {
        switch self {
        case .failure:                          return .error
        case .corruptedData, .unavailable:      return .critical
        }
    }
}
