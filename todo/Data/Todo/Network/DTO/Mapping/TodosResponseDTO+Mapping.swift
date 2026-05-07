//
//  TodosResponseDTO+Mapping.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

extension TodosResponseDTO {
    func toDomain() -> [Todo] {
        todos.map { Todo(from: $0) }
    }
}
