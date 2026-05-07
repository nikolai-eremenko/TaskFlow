//
//  DefaultTodoRepositoryTests.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 22.04.2026.
//

import Foundation
import XCTest
@testable import todo

final class DefaultTodoRepositoryTests: XCTestCase {

    func test_bootstrapIfNeeded_whenNotLoaded_fetchesAndSaves() async throws {
        let (sut, api, storage, settings) = makeSUT()

        settings.storage[SettingsStorageKey.hasLoadedRemote.rawValue] = false

        let dto = TodosResponseDTO.mock(todos: [.mock()])

        api.fetchTodosResult = .success(dto)

        try await sut.bootstrapIfNeeded(traceId: UUID())

        XCTAssertEqual(api.fetchTodosCallCount, 1)
        XCTAssertEqual(storage.upsertCallCount, 1)
        XCTAssertEqual(storage.lastUpsertedTodos.count, 1)
        XCTAssertEqual(storage.lastUpsertedTodos.first?.title, "Test todo")
        XCTAssertEqual(settings.savedValues[SettingsStorageKey.hasLoadedRemote.rawValue] as? Bool, true)
    }

    func test_bootstrapIfNeeded_whenAlreadyLoaded_skipsFetch() async throws {
        let (sut, api, storage, settings) = makeSUT()

        settings.storage[SettingsStorageKey.hasLoadedRemote.rawValue] = true

        try await sut.bootstrapIfNeeded(traceId: UUID())

        XCTAssertEqual(api.fetchTodosCallCount, 0)
        XCTAssertEqual(storage.upsertCallCount, 0)
    }

    func test_observe_forwardsStorageChanges() async {
        let (sut, _, storage, _) = makeSUT()
        let todo = Todo.mock()
        let expected = TodoChange.reload([todo])

        storage.observeStream = AsyncStream { continuation in
            continuation.yield(expected)
            continuation.finish()
        }

        var iterator = sut.observe(traceId: UUID()).makeAsyncIterator()

        let received = await iterator.next()

        XCTAssertEqual(received, expected)
    }

    func test_create_callsUpsert() async throws {
        let (sut, _, storage, _) = makeSUT()

        let todo = Todo.mock()

        try await sut.create(todo: todo, traceId: UUID())

        XCTAssertEqual(storage.upsertCallCount, 1)
    }

    func test_update_callsUpsert() async throws {
        let (sut, _, storage, _) = makeSUT()

        let todo = Todo.mock()

        try await sut.update(todo: todo, traceId: UUID())

        XCTAssertEqual(storage.upsertCallCount, 1)
    }

    func test_toggleTodoCompletion_togglesFlag() async throws {
        let (sut, _, storage, _) = makeSUT()

        let todo = Todo.make(isCompleted: false)
        storage.fetchResult = todo

        try await sut.toggleTodoCompletion(id: todo.id, traceId: UUID())

        let updated = storage.lastUpsertedTodos.first

        XCTAssertEqual(updated?.isCompleted, true)
        XCTAssertEqual(updated?.id, todo.id)
    }

    func test_toggleTodoCompletion_whenTodoNotFound_doesNothing() async throws {

        let (sut, _, storage, _) = makeSUT()

        storage.fetchResult = nil

        try await sut.toggleTodoCompletion(
            id: UUID(),
            traceId: UUID()
        )

        XCTAssertEqual(storage.fetchCallCount, 1)
        XCTAssertEqual(storage.upsertCallCount, 0)
    }

    func test_delete_callsDelete() async throws {
        let (sut, _, storage, _) = makeSUT()

        try await sut.delete(id: UUID(), traceId: UUID())

        XCTAssertEqual(storage.deleteCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: DefaultTodoRepository,
        api: MockTodoAPIService,
        storage: MockTodoStorage,
        settings: MockSettingsStorage
    ) {
        let api = MockTodoAPIService()
        let storage = MockTodoStorage()
        let settings = MockSettingsStorage()
        let logger = NullLogger()

        let sut = DefaultTodoRepository(
            api: api,
            storage: storage,
            settingsStorage: settings,
            logger: logger
        )

        return (sut, api, storage, settings)
    }
}
