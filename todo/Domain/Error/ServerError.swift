//
//  ServerError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum ServerError: Error {

    /// 401
    case unauthorized

    /// 403
    case forbidden

    /// 404
    case notFound

    /// 409
    case conflict

    /// 429
    case tooManyRequests

    /// 5xx
    case serverError

    /// 4xx
    case clientError

    /// decoding errors from server response
    case decodingFailed

    /// custom server-defined error
    case custom
}

extension ServerError {
    var logLevel: LogLevel {
        switch self {
        case .unauthorized, .forbidden:     return .error
        case .tooManyRequests:              return .warning
        case .serverError:                  return .critical
        case .decodingFailed:               return .critical
        default:                            return .error
        }
    }
}
