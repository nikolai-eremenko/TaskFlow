//
//  TodoListRouterInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import UIKit

protocol TodoListRouterInput: AnyObject {
    func openEditTodo(id: UUID, traceId: UUID)
    func openCreateTodo(traceId: UUID)
    func shareTodo(item: TodoShareItem, traceId: UUID)
}
