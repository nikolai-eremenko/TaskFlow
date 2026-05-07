//
//  TodoEntity+CoreDataProperties.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import CoreData
import Foundation

extension TodoEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var serverId: NSNumber?
    @NSManaged var title: String
    @NSManaged var taskDescription: String?
    @NSManaged var createdAt: Date
    @NSManaged var isCompleted: Bool
}
