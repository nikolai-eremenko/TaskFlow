//
//  PreviewAppLogger.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import Foundation

final class PreviewAppLogger: AppLogger {
    func log(
        _ message: @autoclosure @escaping () -> String,
        level: LogLevel,
        context: LogContext
    ) {}

    func log(
        _ error: any Error,
        level: LogLevel,
        context: LogContext
    ) {}
}
