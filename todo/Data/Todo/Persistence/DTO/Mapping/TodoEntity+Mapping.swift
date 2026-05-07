//
//  TodoEntity+Mapping.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData
import Foundation

extension TodoEntity {

    func update(from model: Todo) {
        self.id = model.id

        if let serverId = model.serverId {
            self.serverId = NSNumber(value: serverId)
        } else {
            self.serverId = nil
        }

        self.title = model.title
        self.taskDescription = model.taskDescription
        self.isCompleted = model.isCompleted

        if isInserted {
            self.createdAt = model.createdAt
        }
    }
}

extension Todo {

    init(entity: TodoEntity) {
        self.init(
            id: entity.id,
            serverId: entity.serverId?.intValue,
            title: entity.title,
            taskDescription: entity.taskDescription,
            createdAt: entity.createdAt,
            isCompleted: entity.isCompleted
        )
    }
}
