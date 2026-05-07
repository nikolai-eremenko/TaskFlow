//
//  SettingsStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 24.04.2026.
//

import Foundation

protocol SettingsStorage {

    func load<Value>(
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) -> Value?

    func save<Value>(
        _ value: Value,
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    )

    func remove<Value>(
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    )
}
