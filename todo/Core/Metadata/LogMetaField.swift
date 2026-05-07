//
//  LogMetaField.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

enum LogMetaField: String, CaseIterable {

    case env
    case version
    case build
    case device
    case systemVersion

    // Core
    case provider
    case operation
    case attempt
    case duration

    // Generic values
    case count
    case size
    case width
    case height
    case quality
    case cropRatio
    case identifier
    case source
    case reason
    case key
    case value
    case maskedValue
    case storageKey
    case type
    case query

    // Errors
    case errorType
    case errorCode
    case errorDomain

    // HTTP
    case url
    case method
    case target
    case responseSize
    case requestSize
    case statusCode
}
