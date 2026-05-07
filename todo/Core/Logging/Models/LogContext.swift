//
//  LogContext.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct LogContext {
    let file: String
    let function: String
    let line: Int
    let category: LogCategory
    /// Optional metadata associated with this log entry (key-value pairs).
    let metadata: [LogMetaField: String]?
    /// A unique identifier for tracing this log entry across systems.
    let traceId: UUID?

    init(
        file: String,
        function: String,
        line: Int,
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        traceId: UUID? = nil
    ) {
        self.file = file
        self.function = function
        self.line = line
        self.category = category
        self.metadata = metadata
        self.traceId = traceId
    }
}
