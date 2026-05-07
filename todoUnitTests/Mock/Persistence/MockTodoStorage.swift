//
//  MockTodoStorage.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 22.04.2026.
//

import Foundation
@testable import todo

final class MockTodoStorage: TodoStorage {

    var upsertCallCount = 0
    var deleteCallCount = 0
    var fetchCallCount = 0
    var updateSearchCallCount = 0
    var lastUpsertedTodos: [Todo] = []

    var fetchResult: Todo?
    var observeStream: AsyncStream<TodoChange> = .init { _ in }

    func upsert(_ todos: [Todo], traceId: UUID) async throws {
        upsertCallCount += 1
        lastUpsertedTodos = todos
    }

    func fetch(id: UUID, traceId: UUID) async throws -> Todo? {
        fetchCallCount += 1
        return fetchResult
    }

    func delete(id: UUID, traceId: UUID) async throws {
        deleteCallCount += 1
    }

    func updateSearch(text: String) {
        updateSearchCallCount += 1
    }

    func observeChanges() -> AsyncStream<TodoChange> {
        observeStream
    }
}
