//
//  ErrorMapping.swift
//  todo
//
//  Created by Nikolai Eremenko on 14.05.2026.
//

import Foundation

protocol ErrorMapping {
    func map(_ error: CoreError) -> DomainError
}
