//
//  CoreError.swift
//  
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum CoreError: Error {
    case networkService(NetworkServiceError)

    var statusCode: Int? {
        switch self {
        case .networkService(let error):
            return error.statusCode
        }
    }
}

extension CoreError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {
        case .networkService(let error):
            return error.logLevel
        }
    }
}
