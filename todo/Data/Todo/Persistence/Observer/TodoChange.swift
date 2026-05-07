//
//  TodoChange.swift
//  todo
//
//  Created by Nikolai Eremenko on 01.05.2026.
//

import Foundation

enum TodoChange: Equatable {
    case reload([Todo])
    case update(Todo)
}
