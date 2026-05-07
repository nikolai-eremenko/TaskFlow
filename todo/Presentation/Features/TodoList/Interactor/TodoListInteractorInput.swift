//
//  TodoListInteractorInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoListInteractorInput: AnyObject {
    func start(traceId: UUID)
    func loadInitialData(traceId: UUID) async
    func deleteTodo(id: UUID, traceId: UUID) async
    func toggleCompletion(id: UUID, traceId: UUID) async
    func searchTodos(text: String, traceId: UUID) async
}
