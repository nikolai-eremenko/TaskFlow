//
//  TodoCoordinating.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import Foundation

protocol TodoCoordinating {
    func showTodoList()
    func showCreateTodo(traceId: UUID)
    func showEditTodo(todoId: UUID, traceId: UUID)
}
