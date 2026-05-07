//
//  NetworkService.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol NetworkService {

    func performRequest<T: Decodable>(
        _ request: AppTarget,
        traceId: UUID
    ) async throws -> T

    func performVoidRequest(
        _ request: AppTarget,
        traceId: UUID
    ) async throws
}
