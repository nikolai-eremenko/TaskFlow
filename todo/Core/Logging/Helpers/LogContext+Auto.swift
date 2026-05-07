//
//  LogContext+Auto.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

extension LogContext {

    static func auto(
        category: LogCategory,
        metadata: [LogMetaField: String]? = nil,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line,
        traceId: UUID? = nil
    ) -> LogContext {
        let shortFile = URL(fileURLWithPath: file).lastPathComponent

        return LogContext(
            file: shortFile,
            function: function,
            line: line,
            category: category,
            metadata: metadata,
            traceId: traceId
        )
    }
}
