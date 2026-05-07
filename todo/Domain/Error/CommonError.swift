//
//  CommonError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum CommonError: Error {
    case cancelled
    case unknown
}

extension CommonError: LogLevelProvider {
    var logLevel: LogLevel {
        switch self {
        case .cancelled:        return .info
        case .unknown:          return .error
        }
    }
}
