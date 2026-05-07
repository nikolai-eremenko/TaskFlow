//
//  TodoListResponse+Mock.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 22.04.2026.
//

import Foundation
@testable import todo

extension TodosResponseDTO {

    static func mock(
        todos: [TodoDTO] = [.mock()]
    ) -> TodosResponseDTO {
        TodosResponseDTO(
            todos: todos,
            total: todos.count,
            skip: 0,
            limit: todos.count
        )
    }
}
