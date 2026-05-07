//
//  TodoListViewInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoListViewInput: AnyObject {
    func render(change: TodoListViewChange, todosCount: Int)
    func showError(message: String)
}
