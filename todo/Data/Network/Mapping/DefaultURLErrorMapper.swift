//
//  DefaultURLErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct DefaultURLErrorMapper: URLErrorMapper {

    /// Maps underlying `URLError`s into `NetworkServiceError`.
    ///
    /// Handles network connectivity issues, timeouts, and unknown errors
    /// consistently for the app.
    ///
    /// - Parameter error: The underlying `Error` returned by Moya
    /// - Returns: Corresponding `NetworkServiceError`
    func map(_ error: URLError) -> NetworkServiceError {
        switch error.code {
        case .notConnectedToInternet:                   return .noInternet(underlying: error)
        case .timedOut:                                 return .timeout(underlying: error)
        case .networkConnectionLost:                    return .networkConnectionLost(underlying: error)
        case .cannotFindHost, .cannotConnectToHost:     return .cannotFindHost(underlying: error)
        case .cancelled:                                return .cancelled
        default:                                        return .underlying(error)
        }
    }
}
