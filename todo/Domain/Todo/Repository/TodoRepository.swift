//
//  TodoRepository.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation

protocol TodoRepository {
    func observe(traceId: UUID) -> AsyncStream<TodoChange>
    func bootstrapIfNeeded(traceId: UUID) async throws
    func fetch(id: UUID, traceId: UUID) async throws -> Todo?
    func create(todo: Todo, traceId: UUID) async throws
    func update(todo: Todo, traceId: UUID) async throws
    func delete(id: UUID, traceId: UUID) async throws
    func toggleTodoCompletion(id: UUID, traceId: UUID) async throws
    func search(text: String, traceId: UUID) async throws
}
