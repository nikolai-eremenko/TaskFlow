//
//  DefaultSettingsStorage.swift
//  todo
//
//  Created by Nikolai Eremenko on 24.04.2026.
//

import Foundation

final class DefaultSettingsStorage: SettingsStorage {

    // MARK: - Private properties

    private let defaults: UserDefaults
    private let logger: AppLogger

    private enum LogMessage: String {
        case loaded     = "Value loaded"
        case saved      = "Value saved"
        case removed    = "Value removed"
        case notFound   = "Value not found"
    }

    // MARK: - Initializers

    init(
        defaults: UserDefaults = .standard,
        logger: AppLogger
    ) {
        self.defaults = defaults
        self.logger = logger
    }

    // MARK: - Public Methods

    func load<Value>(for key: SettingsStorageKey<Value>, traceId: UUID) -> Value? {
        guard let value = defaults.value(forKey: key.rawValue) as? Value else {
            log(logMessage: .notFound, key: key, traceId: traceId)

            return nil
        }

        log(logMessage: .loaded, key: key, value: value, traceId: traceId)

        return value
    }

    func save<Value>(
        _ value: Value,
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) {
        defaults.set(value, forKey: key.rawValue)
        log(logMessage: .saved, key: key, value: value, traceId: traceId)
    }

    func remove<Value>(
        for key: SettingsStorageKey<Value>,
        traceId: UUID
    ) {
        defaults.removeObject(forKey: key.rawValue)
        log(logMessage: .removed, key: key, traceId: traceId)
    }

    // MARK: - Private Methods

    private func log<Value>(
        logMessage: LogMessage,
        key: SettingsStorageKey<Value>,
        value: Value? = nil,
        traceId: UUID
    ) {
        var metadata = LogMetadataBuilder()

        metadata.storageKey(key.rawValue)

        if let value {
            metadata.value("\(value)")
        }

        logger.debug(
            logMessage.rawValue,
            category: .persistence,
            metadata: metadata.build(),
            traceId: traceId
        )
    }
}
