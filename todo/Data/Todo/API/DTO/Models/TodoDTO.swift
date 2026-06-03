//
//  TodoDTO.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct TodoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
