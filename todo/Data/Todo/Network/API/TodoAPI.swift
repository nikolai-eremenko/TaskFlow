//
//  TodoAPI.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import Moya
import Alamofire

enum TodoAPI: AppTarget {

    /// Fetch list of available countries
    ///
    /// Public endpoint, does not require authorization
    case todos
}

extension TodoAPI: TargetType {

    /// Base URL is intentionally unused.
    ///
    /// The actual base URL is injected via `endpointClosure`
    /// inside `MoyaProvider` configuration to support:
    /// - multiple environments
    /// - testability
    /// - dependency injection
    var baseURL: URL {
        preconditionFailure("baseURL must not be used directly; it's overridden in endpointClosure")
    }

    /// Endpoint path relative to base URL
    var path: String {
        switch self {
        case .todos:
            return "/todos/"
        }
    }

    /// HTTP method used for the request
    var method: Moya.Method { .get }

    /// Request task describing body and encoding
    var task: Task { .requestPlain }

    /// Default HTTP headers applied to all requests
    ///
    /// Authorization header is intentionally NOT included here.
    /// Authenticated requests are handled via `AuthorizedTarget`.
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    /// Indicates whether this endpoint requires authentication
    ///
    /// This flag is used by the networking layer to decide
    /// whether the request must be wrapped with authorization.
    var requiresAuth: Bool { false }
}
