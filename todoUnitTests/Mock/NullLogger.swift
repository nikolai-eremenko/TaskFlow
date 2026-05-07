//
//  NullLogger.swift
//  todoTests
//
//  Created by Nikolai Eremenko on 05.05.2026.
//

import Foundation
@testable import todo

final class NullLogger: AppLogger {

    func log(
        _ message: @autoclosure @escaping () -> String,
        level: LogLevel,
        context: LogContext
    ) {}

    func log(
        _ error: Error,
        level: LogLevel,
        context: LogContext
    ) {}
}
