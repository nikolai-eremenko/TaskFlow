//
//  NetworkServiceError.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum NetworkServiceError: Error {

    // MARK: - Authorization

    /// 401
    case unauthorized

    /// 403
    case forbidden

    // MARK: - HTTP Specific

    /// 404
    case notFound

    /// 429
    case tooManyRequests

    // MARK: - HTTP Generic

    case client(statusCode: Int, data: Data?)
    case server(statusCode: Int, data: Data?)

    // MARK: - Transport

    case noInternet(underlying: URLError)
    case timeout(underlying: URLError)
    case networkConnectionLost(underlying: URLError)
    case cannotFindHost(underlying: URLError)
    case cancelled

    // MARK: - Decoding

    case decodingFailed(underlying: Error, data: Data?)

    // MARK: - Developer / Configuration

    case requestMappingFailed(underlying: Error)
    case parameterEncodingFailed(underlying: Error)

    // MARK: - Unknown

    case underlying(Error)
}

extension NetworkServiceError {

    var statusCode: Int? {
        switch self {
        case .client(let code, _), .server(let code, _):    return code
        case .unauthorized:                                 return 401
        case .forbidden:                                    return 403
        case .notFound:                                     return 404
        case .tooManyRequests:                              return 429
        default:                                            return nil
        }
    }
}

extension NetworkServiceError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {
        case .cancelled:
            return .debug

        case .noInternet, .timeout, .networkConnectionLost, .tooManyRequests, .unauthorized, .forbidden:
            return .info

        case .client, .cannotFindHost, .notFound:
            return .warning

        case .server:
            return .error

        case .underlying, .decodingFailed, .requestMappingFailed, .parameterEncodingFailed:
            return .critical
        }
    }
}
