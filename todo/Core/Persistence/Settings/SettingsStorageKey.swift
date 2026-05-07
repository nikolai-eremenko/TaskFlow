//
//  SettingsStorageKey.swift
//  todo
//
//  Created by Nikolai Eremenko on 24.04.2026.
//

import Foundation

struct SettingsStorageKey<Value> {

    let rawValue: String

    init(_ rawValue: String) {
        precondition(!rawValue.isEmpty, "SettingsKey name must not be empty")
        self.rawValue = rawValue
    }
}

extension SettingsStorageKey where Value == Bool {
    static let hasLoadedRemote = SettingsStorageKey<Bool>("hasLoadedRemote")
}
