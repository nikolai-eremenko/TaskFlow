//
//  Todo.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Foundation

struct Todo: Equatable {
    let id: UUID
    let serverId: Int?
    let title: String
    let taskDescription: String?
    let createdAt: Date
    let isCompleted: Bool
}
