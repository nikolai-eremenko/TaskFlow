//
//  XcodeConsoleLoggerFactory.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

struct XcodeConsoleLoggerFactory: LoggerFactory {

    func make(resolver: Resolver) -> AppLogger {
        return XcodeConsoleLogger()
    }
}
