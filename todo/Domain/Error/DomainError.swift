//
//  DomainError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum DomainError: Error {
    case connection(ConnectionError)
    case server(ServerError)
    case storage(StorageError)
    case common(CommonError)
}

extension DomainError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {
        case .connection(let error):            return error.logLevel
        case .server(let error):                return error.logLevel
        case .storage(let error):               return error.logLevel
        case .common(let error):                return error.logLevel
        }
    }
}
