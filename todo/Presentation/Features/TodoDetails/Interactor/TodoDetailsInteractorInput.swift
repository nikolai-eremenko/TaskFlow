//
//  TodoDetailsInteractorInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Foundation

protocol TodoDetailsInteractorInput {
    func loadTodo(id: UUID, traceId: UUID) async
    func saveTodo(title: String, description: String?, traceId: UUID) async
}
