//
//  CompositeLogger.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

final class CompositeLogger: AppLogger {

    // MARK: - Private Properties

    /// The list of underlying loggers receiving forwarded messages.
    private let loggers: [AppLogger]

    private let queue: DispatchQueue

    /// Logs below this level are ignored.
    private let minLevel: LogLevel

    // MARK: - Initializers

    init(
        _ loggers: [AppLogger],
        minLevel: LogLevel,
        appInfo: AppInfo
    ) {
        self.loggers = loggers
        self.minLevel = minLevel
        self.queue = DispatchQueue(
            label: "\(appInfo.bundleId).logger", qos: .utility
        )
    }

    // MARK: - Public Methods

    func log(
        _ message: @autoclosure @escaping () -> String,
        level: LogLevel,
        context: LogContext
    ) {
        guard level >= minLevel else { return }

        let resolvedMessage = message()

        queue.async { [loggers, resolvedMessage, level, context] in
            for logger in loggers {
                logger.log(resolvedMessage, level: level, context: context)
            }
        }
    }

    func log(
        _ error: Error,
        level: LogLevel,
        context: LogContext
    ) {
        guard level >= minLevel else { return }

        queue.async { [weak self] in
            guard let self else { return }

            for logger in self.loggers {
                logger.log(error, level: level, context: context)
            }
        }
    }
}
