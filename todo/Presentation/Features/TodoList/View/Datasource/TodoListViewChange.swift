//
//  TodoListViewChange.swift
//  todo
//
//  Created by Nikolai Eremenko on 01.05.2026.
//

import Foundation

enum TodoListViewChange {
    case update(TodoCellViewModel)
    case reload([TodoCellViewModel])
}
