//
//  ConnectionError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum ConnectionError: Error {
    case noInternet
    case timeout
    case connectionLost
    case cannotFindHost
}

extension ConnectionError {

    var logLevel: LogLevel {
        switch self {
        case .noInternet,
                .timeout,
                .connectionLost:
            return .info

        case .cannotFindHost:
            return .error
        }
    }
}
