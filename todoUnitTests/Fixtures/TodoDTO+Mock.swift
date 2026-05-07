//
//  TodoDTO+Mock.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 05.05.2026.
//

import Foundation
@testable import todo

extension TodoDTO {

    static func mock(
        id: Int = 1,
        todo: String = "Test todo",
        completed: Bool = false,
        userId: Int = 1
    ) -> TodoDTO {
        TodoDTO(
            id: id,
            todo: todo,
            completed: completed,
            userId: userId
        )
    }
}
