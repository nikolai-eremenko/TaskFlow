//
//  LogMetadataBuilder.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct LogMetadataBuilder {

    private static let maxValueLength = 100
    private let maxParamsCount = 20

    private var values: [LogMetaField: String] = [:]

    func build() -> [LogMetaField: String] {
        values
    }

    mutating func method(_ method: String) {
        values[.method] = method
    }

    mutating func target(_ name: String) {
        values[.target] = name
    }

    mutating func statusCode(_ code: Int?) {
        if let code {
            values[.statusCode] = "\(code)"
        }
    }

    mutating func reason(_ reason: String) {
        values[.reason] = reason
    }

    mutating func responseSize(_ size: Int) {
        values[.responseSize] = "\(size)"
    }

    mutating func requestSize(_ size: Int) {
        values[.requestSize] = "\(size)"
    }

    mutating func attempt(_ number: Int) {
        values[.attempt] = "\(number)"
    }

    mutating func duration(_ duration: TimeInterval) {
        values[.duration] = String(format: "%.3f", duration)
    }

    mutating func provider(_ name: String) {
        values[.provider] = name
    }

    mutating func count(_ value: Int) {
        values[.count] = "\(value)"
    }

    mutating func width(_ value: Double) {
        values[.width] = "\(value)"
    }

    mutating func height(_ value: Double) {
        values[.height] = "\(value)"
    }

    mutating func cropRatio(_ value: String) {
        values[.cropRatio] = value
    }

    mutating func quality(_ value: CGFloat) {
        values[.quality] = "\(value)"
    }

    mutating func url(_ url: String) {
        values[.url] = Self.sanitizeURL(url)
    }

    mutating func source(_ source: String) {
        values[.source] = source
    }

    mutating func size(_ value: Int) {
        values[.size] = "\(value)"
    }

    mutating func storageKey(_ key: String) {
        values[.storageKey] = key
    }

    mutating func key(_ key: String) {
        values[.key] = Self.sanitize(
            key: .key,
            value: key
        )
    }

    mutating func value(_ value: String) {
        values[.value] = value
    }

    mutating func query(_ query: String) {
        values[.query] = query
    }

    mutating func maskedValue(_ value: String) {
        values[.maskedValue] = Self.sanitize(
            key: .value,
            value: value
        )
    }

    mutating func type(_ type: String) {
        values[.type] = type
    }

    private static func sanitize(key: LogMetaField, value: String) -> String {
        return String(value.prefix(100))
    }

    private static func sanitizeURL(_ url: String) -> String {
        return String(url.prefix(maxValueLength))
    }
}
