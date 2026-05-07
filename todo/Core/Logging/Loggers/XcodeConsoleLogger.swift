//
//  XcodeConsoleLogger.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

final class XcodeConsoleLogger: AppLogger {

    // MARK: - Private Properties

    private let loggerFormatter = XcodeConsoleLoggerFormatter()

    // MARK: - Public Methods

    func log(
        _ message: @autoclosure @escaping () -> String,
        level: LogLevel,
        context: LogContext
    ) {

        let output = loggerFormatter.format(
            message: message(),
            level: level,
            context: context
        )

        print(output)
    }

    func log(
        _ error: Error,
        level: LogLevel,
        context: LogContext
    ) {
        let output = loggerFormatter.format(
            message: "\(type(of: error)): \(error.localizedDescription)",
            level: level,
            context: context
        )

        print(output)
    }
}

private struct XcodeConsoleLoggerFormatter {
    func format(
        message: String,
        level: LogLevel,
        context: LogContext
    ) -> String {
        let time = AppDateFormatters.loggerTimeOnly.string(from: Date())
        let levelEmoji = level.emoji
        let location = "\(shortFile(context.file)):\(context.line)"
        let categoryEmoji = context.category.emoji
        let categoryName = context.category.rawValue

        let tracePart: String

        if let traceId = context.traceId {
            tracePart = "[\(shortTraceId(traceId))] "
        } else {
            tracePart = ""
        }

        // First line
        var result =
        "\(levelEmoji) \(categoryEmoji) \(time) " +
        "\(tracePart)" +
        "[\(categoryName)] " +
        "\(location) ▸ \(message)"

        // Second line
        var details: [String] = []

        if let metadata = context.metadata, !metadata.isEmpty {
            let metaString = metadata.map { "    \($0.key): \($0.value)" }.joined(separator: "\n")
            details.append("  📋 Metadata:\n\(metaString)")
        }

        if level >= .warning {
            details.append("  🔍 function: \(context.function)")
        }

        if !details.isEmpty {
            result += "\n" + details.joined(separator: "\n")
        }

        return result
    }

    private func shortFile(_ file: String) -> String {
        (file as NSString).lastPathComponent
    }

    private func shortTraceId(_ id: UUID) -> String {
        id.uuidString.prefix(8).uppercased()
    }
}
