//
//  TodosResponseDTO.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct TodosResponseDTO: Decodable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
