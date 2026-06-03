//
//  AuthorizedTarget.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import Moya

enum AuthorizedTarget: TargetType {

    case authorized(AppTarget, token: String)

    var baseURL: URL { api.baseURL }
    var path: String { api.path }
    var method: Moya.Method { api.method }
    var task: Task { api.task }
    var sampleData: Data { api.sampleData }

    var headers: [String: String]? {
        var headers = api.headers ?? [:]

        if case .authorized(_, let token) = self {
            headers["Authorization"] = "Bearer \(token)"
        }

        return headers
    }

    // MARK: - Private Helpers

    private var api: AppTarget {
        switch self {
        case .authorized(let api, _): return api
        }
    }
}
