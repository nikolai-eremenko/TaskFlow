//
//  EnvironmentConfiguration.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct EnvironmentConfiguration {
    let baseURL: URL
    let useStubbedProvider: Bool
    let logLevel: LogLevel
    let loggerFactories: [LoggerFactory]
}
