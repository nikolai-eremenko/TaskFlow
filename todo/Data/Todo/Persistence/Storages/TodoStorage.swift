//
//  TodoStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Foundation

protocol TodoStorage {
    func upsert(_ todos: [Todo], traceId: UUID) async throws(CoreError)
    func fetch(id: UUID, traceId: UUID) async throws(CoreError) -> Todo?
    func delete(id: UUID, traceId: UUID) async throws(CoreError)
    func updateSearch(text: String)
    func observeChanges() -> AsyncStream<TodoChange>
}
