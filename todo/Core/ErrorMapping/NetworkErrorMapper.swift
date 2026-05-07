//
//  NetworkErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class NetworkErrorMapper: ErrorMapper {

    func canMap(_ error: Error) -> Bool {
        error is NetworkServiceError
    }

    // swiftlint:disable cyclomatic_complexity
    func map(_ error: Error) -> DomainError {
        guard let serviceError = error as? NetworkServiceError else { return .common(.unknown) }

        switch serviceError {

            // MARK: - HTTP Status / API errors
        case .unauthorized:                                     return .server(.unauthorized)     // 401
        case .forbidden:                                        return .server(.forbidden)        // 403
        case .notFound:                                         return .server(.notFound)         // 404
        case .tooManyRequests:                                  return .server(.tooManyRequests)  // 429

        case .client:                                           return .server(.clientError)
        case .server:                                           return .server(.serverError)

            // MARK: - HTTP Status / API errors
        case .noInternet:                                       return .connection(.noInternet)
        case .timeout:                                          return .connection(.timeout)
        case .networkConnectionLost:                            return .connection(.connectionLost)
        case .cannotFindHost:                                   return .connection(.cannotFindHost)
        case .cancelled:                                        return .common(.cancelled)

            // MARK: - Decoding

        case .decodingFailed:                                   return .server(.decodingFailed)

            // MARK: - Developer / Configuration errors

        case .requestMappingFailed, .parameterEncodingFailed:   return .common(.unknown)
        case .underlying:                                       return .common(.unknown)
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
