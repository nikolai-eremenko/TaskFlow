//
//  LogLevel.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import os

/// Represents the severity level of a log message or error.
///
/// Levels are ordered from lowest to highest severity:
/// - `debug`: General information, debug traces, or non-critical events.
/// - `warning`: Potential issues that should be monitored.
/// - `error`: Errors requiring attention, may affect functionality.
/// - `critical`: Severe errors that can lead to crashes or major failures.
///
/// # Guidelines
/// - Use `.debug` for normal application events, e.g., "User opened screen X".
/// - Use `.warning` for recoverable issues or unusual behavior, e.g., "Slow network response".
/// - Use `.error` for unexpected failures, e.g., "Failed to load user profile".
/// - Use `.critical` for unrecoverable issues, crashes, or security-related problems.
///
/// # Example
/// ```swift
/// logger.log("User login successful", level: .debug, context: context)
/// logger.log(LoginError.invalidCredentials, level: .error, context: context)
/// logger.log(DatabaseError.unreachable, level: .critical, context: context)
/// ```
enum LogLevel: Int, Comparable, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case critical = 4

    var isUserVisible: Bool {
        self >= .warning
    }

    var isError: Bool {
        self >= .error
    }

    var isCritical: Bool {
        self == .critical
    }

    // MARK: - Comparable implementation

    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Visual representation

extension LogLevel {

    var emoji: String {
        switch self {
        case .debug:                    return "🔍"
        case .info:                     return "ℹ️"
        case .warning:                  return "⚠️"
        case .error:                    return "❌"
        case .critical:                 return "🔥"
        }
    }

    var displayName: String {
        switch self {
        case .debug:                    return "DEBUG"
        case .info:                     return "INFO"
        case .warning:                  return "WARNING"
        case .error:                    return "ERROR"
        case .critical:                 return "CRITICAL"
        }
    }
}

// MARK: - Filtering and sampling

extension LogLevel {
    var sampleRate: Double {
        switch self {
        case .debug:                    return 0.1
        case .info:                     return 0.5
        case .warning:                  return 1.0
        case .error:                    return 1.0
        case .critical:                 return 1.0
        }
    }
}

// MARK: - System log level mapping

extension LogLevel {
    var osLogType: OSLogType {
        switch self {
        case .debug:                    return .debug
        case .info:                     return .info
        case .warning:                  return .default
        case .error:                    return .error
        case .critical:                 return .fault
        }
    }
}

// MARK: - Factory methods

extension LogLevel {
    static func from(_ osLogType: OSLogType) -> LogLevel? {
        switch osLogType {
        case .debug:                    return .debug
        case .info:                     return .info
        case .default:                  return .warning
        case .error:                    return .error
        default:                        return nil
        }
    }
}

// MARK: - Convenience extensions

extension LogLevel {
    @inline(__always)
    func shouldLog(minLevel: LogLevel) -> Bool {
        self.rawValue >= minLevel.rawValue
    }

    func shouldSample() -> Bool {
        guard sampleRate < 1.0 else { return true }
        return Double.random(in: 0...1) < sampleRate
    }
}
