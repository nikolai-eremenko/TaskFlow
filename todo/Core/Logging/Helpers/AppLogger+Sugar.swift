//
//  AppLogger+Sugar.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

extension AppLogger {

    func debug(
        _ message: @autoclosure @escaping () -> String,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(message(), level: .debug, context: context)
    }

    func warning(
        _ message: @autoclosure @escaping () -> String,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(message(), level: .warning, context: context)
    }

    func error(
        _ message: @autoclosure @escaping () -> String,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(message(), level: .error, context: context)
    }

    func critical(
        _ message: @autoclosure @escaping () -> String,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(message(), level: .critical, context: context)
    }

    // MARK: - Errors

    func logError(
        _ error: Error,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        let level = (error as? LogLevelProvider)?.logLevel ?? .error

        log(error, level: level, context: context)
    }

    func debug(
        _ error: Error,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(error, level: .debug, context: context)
    }

    func warning(
        _ error: Error,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(error, level: .warning, context: context)
    }

    func error(
        _ error: Error,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(error, level: .error, context: context)
    }

    func critical(
        _ error: Error,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let context = LogContext.auto(
            category: category,
            metadata: metadata,
            file: file,
            function: function,
            line: line,
            traceId: traceId
        )

        log(error, level: .critical, context: context)
    }
}
