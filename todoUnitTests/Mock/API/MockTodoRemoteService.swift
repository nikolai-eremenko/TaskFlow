//
//  MockTodoRemoteService.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 22.04.2026.
//

import Foundation
@testable import todo

final class MockTodoRemoteService: TodoRemoteService {

    var fetchTodosCallCount = 0
    var fetchTodosResult: Result<TodosResponseDTO, Error> = .failure(NSError())

    func fetchTodos(traceId: UUID) async throws -> TodosResponseDTO {
        fetchTodosCallCount += 1
        return try fetchTodosResult.get()
    }
}
