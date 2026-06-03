//
//  AuthorizedNetworkService.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol AuthorizedNetworkService {

    func requestWithAutoRefresh<T: Decodable>(
        _ request: AppTarget,
        type: T.Type,
        traceId: UUID
    ) async throws(CoreError) -> T

    func requestVoidWithAutoRefresh(
        _ request: AppTarget,
        traceId: UUID
    ) async throws(CoreError)
}
