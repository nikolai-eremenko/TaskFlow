//
//  DefaultHTTPStatusCodeMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct DefaultHTTPStatusCodeMapper: HTTPStatusCodeMapper {

    /// Maps HTTP status codes into `NetworkServiceError`.
    ///
    /// - Parameter response: The `Response` returned by network
    /// - Returns: Corresponding `NetworkServiceError`
    func map(statusCode: Int, data: Data?) -> NetworkServiceError {
        switch statusCode {
        case 401:           return .unauthorized
        case 403:           return .forbidden
        case 404:           return .notFound
        case 429:           return .tooManyRequests
        case 400..<500:     return .client(statusCode: statusCode, data: data)
        case 500..<600:     return .server(statusCode: statusCode, data: data)
        default:            return .underlying(NSError(domain: "HTTPStatus", code: statusCode))
        }
    }
}
