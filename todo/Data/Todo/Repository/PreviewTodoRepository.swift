//
//  PreviewTodoRepository.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import Foundation

enum PreviewTodoRepositoryMode {
    case loaded
    case empty
    case error
}

final class PreviewTodoRepository: TodoRepository {

    private let mode: PreviewTodoRepositoryMode

    init(mode: PreviewTodoRepositoryMode) {
        self.mode = mode
    }

    func observe(traceId: UUID) -> AsyncStream<TodoChange> {
        AsyncStream { continuation in
            switch mode {
            case .loaded:       continuation.yield(.reload(Self.sampleTodos()))
            case .empty:        continuation.yield(.reload([]))
            case .error:        continuation.yield(.reload([]))
            }
        }
    }

    func bootstrapIfNeeded(traceId: UUID) async throws(DomainError) {
        if mode == .error {
            throw DomainError.connection(.noInternet)
        }
    }

    func fetch(id: UUID, traceId: UUID) async throws(DomainError) -> Todo? {
        if mode == .error {
            throw DomainError.storage(.failure)
        }

        return Self.previewTodo
    }

    func create(todo: Todo, traceId: UUID) async throws(DomainError) {}
    func update(todo: Todo, traceId: UUID) async throws(DomainError) {}
    func delete(id: UUID, traceId: UUID) async throws(DomainError) {}
    func toggleTodoCompletion(id: UUID, traceId: UUID) async throws(DomainError) {}
    func search(text: String, traceId: UUID) {}
}

private extension PreviewTodoRepository {

    static func sampleTodos() -> [Todo] {
        (0..<30).map { _ in
            Todo(
                id: UUID(),
                serverId: nil,
                title: makeRandomTitle(),
                taskDescription: makeRandomDescription(),
                createdAt: makeRandomDateWithinLast7Days(),
                isCompleted: Bool.random()
            )
        }
    }

    private static func makeRandomTitle() -> String {
        let words = loremWords.shuffled()
        let count = Int.random(in: 1...10)
        return words.prefix(count).joined(separator: " ")
    }

    private static func makeRandomDescription() -> String? {

        let count = Int.random(in: 0...30)
        guard count > 0 else { return nil }

        let words = loremWords.shuffled()
        return words.prefix(count).joined(separator: " ")
    }

    private static func makeRandomDateWithinLast7Days() -> Date {
        let now = Date()
        let week: TimeInterval = 7 * 24 * 60 * 60
        let offset = TimeInterval.random(in: 0...week)
        return now.addingTimeInterval(-offset)
    }

    private static let loremWords: [String] = [
        "lorem", "ipsum", "dolor", "sit", "amet",
        "consectetur", "adipiscing", "elit", "sed", "do",
        "eiusmod", "tempor", "incididunt", "ut", "labore",
        "et", "dolore", "magna", "aliqua", "enim",
        "ad", "minim", "veniam", "quis", "nostrud",
        "exercitation", "ullamco", "laboris", "nisi", "aliquip",
        "ex", "ea", "commodo", "consequat"
    ]

    private static let previewTodo = Todo(
        id: UUID(),
        serverId: nil,
        title: "Buy groceries for the weekend",
        taskDescription: """
    Milk
    Eggs
    Bread
    Cheese
    Apples
    """,
        createdAt: .now,
        isCompleted: false
    )
}
