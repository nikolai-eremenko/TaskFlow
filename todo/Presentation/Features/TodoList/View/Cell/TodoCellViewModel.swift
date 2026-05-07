//
//  TodoCellViewModel.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Foundation

struct TodoCellViewModel {
    let id: UUID
    let title: String
    let description: String?
    let isCompleted: Bool
    let dateText: String

    init(todo: Todo) {
        self.id = todo.id
        self.title = todo.title
        self.description = todo.taskDescription
        self.isCompleted = todo.isCompleted
        self.dateText =  AppDateFormatters.localizedDateOnly.string(from: todo.createdAt)
    }
}
