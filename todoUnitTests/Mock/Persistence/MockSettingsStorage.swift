//
//  MockSettingsStorage.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 05.05.2026.
//

import Foundation
@testable import todo

final class MockSettingsStorage: SettingsStorage {

    var storage: [String: Any] = [:]
    var savedValues: [String: Any] = [:]

    func load<Value>(
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) -> Value? {
        storage[key.rawValue] as? Value
    }

    func save<Value>(
        _ value: Value,
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) {
        storage[key.rawValue] = value
        savedValues[key.rawValue] = value
    }

    func remove<Value>(
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) {
        storage.removeValue(forKey: key.rawValue)
    }
}
