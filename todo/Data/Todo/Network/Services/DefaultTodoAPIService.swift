//
//  DefaultTodoAPIService.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation
import Moya

final class DefaultTodoAPIService: TodoAPIService {

    private let network: NetworkService
    private let logger: AppLogger

    // MARK: - Init

    init(
        network: NetworkService,
        logger: AppLogger
    ) {
        self.network = network
        self.logger = logger
    }

    // MARK: - Public Methods

    func fetchTodos(traceId: UUID) async throws -> TodosResponseDTO {
        try await network.performRequest(TodoAPI.todos, traceId: traceId)
    }
}
