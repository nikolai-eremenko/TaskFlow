//
//  TodoDetailsInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 21.04.2026.
//

import Foundation

struct TodoDetailsInput {
    let mode: Mode

    enum Mode {
        case create
        case edit(id: UUID)
    }
}
