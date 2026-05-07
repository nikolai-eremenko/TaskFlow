//
//  Todo+Mock.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 22.04.2026.
//

import Foundation
@testable import todo

extension Todo {

    static func make(
        id: UUID = UUID(),
        serverId: Int? = nil,
        title: String = "Test Todo",
        taskDescription: String? = nil,
        createdAt: Date = Date(timeIntervalSince1970: 0),
        isCompleted: Bool = false
    ) -> Todo {
        Todo(
            id: id,
            serverId: serverId,
            title: title,
            taskDescription: taskDescription,
            createdAt: createdAt,
            isCompleted: isCompleted
        )
    }

    static func mock(
        isCompleted: Bool = false
    ) -> Todo {
        make(
            title: "Test Todo",
            isCompleted: isCompleted
        )
    }

    static func completed() -> Todo {
        make(isCompleted: true)
    }

    static func withServerId(_ id: Int) -> Todo {
        make(serverId: id)
    }

    static func emptyTitle() -> Todo {
        make(title: "")
    }
}
