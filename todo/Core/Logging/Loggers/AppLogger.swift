//
//  AppLogger.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol AppLogger: Sendable {

    func log(
        _ message: @autoclosure @escaping () -> String,
        level: LogLevel,
        context: LogContext
    )

    func log(
        _ error: Error,
        level: LogLevel,
        context: LogContext
    )
}
