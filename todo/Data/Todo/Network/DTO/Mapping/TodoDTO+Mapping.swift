//
//  TodoDTO+Mapping.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

extension Todo {

    init(from dto: TodoDTO) {
        self.id = UUID()
        self.serverId = dto.id
        self.title = dto.todo
        self.taskDescription = Self.makeRandomDescription()
        self.createdAt = Self.makeRandomDateWithinNext7Days()
        self.isCompleted = dto.completed
    }

    // MARK: - Random helpers

    private static func makeRandomDateWithinNext7Days() -> Date {
        let now = Date()
        let secondsIn7Days: TimeInterval = 7 * 24 * 60 * 60
        let randomInterval = TimeInterval.random(in: 0...secondsIn7Days)
        return now.addingTimeInterval(randomInterval)
    }

    private static func makeRandomDescription() -> String? {
        let loremLines = [
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            "Ut enim ad minim veniam, quis nostrud exercitation.",
            "Duis aute irure dolor in reprehenderit in voluptate velit esse.",
            "Excepteur sint occaecat cupidatat non proident."
        ]

        let numberOfLines = Int.random(in: 0...3)

        guard numberOfLines > 0 else { return nil }

        return loremLines
            .shuffled()
            .prefix(numberOfLines)
            .joined(separator: " ")
    }
}
