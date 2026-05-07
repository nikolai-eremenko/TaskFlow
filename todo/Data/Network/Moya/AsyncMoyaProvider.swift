//
//  AsyncMoyaProvider.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import Moya

extension MoyaProvider {

    func asyncRequestResponse(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension Response: @unchecked @retroactive Sendable {}
