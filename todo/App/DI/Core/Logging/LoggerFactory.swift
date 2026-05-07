//
//  LoggerFactory.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Swinject

protocol LoggerFactory {
    func make(resolver: Resolver) -> AppLogger
}
