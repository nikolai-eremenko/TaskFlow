//
//  DefaultTodoRemoteService.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation
import Moya

final class DefaultTodoRemoteService: TodoRemoteService {

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

    func fetchTodos(traceId: UUID) async throws(CoreError) -> TodosResponseDTO {
        try await network.performRequest(TodoTarget.todos, traceId: traceId)
    }
}
