//
//  PreviewErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import Foundation

final class PreviewErrorMapper: ErrorMapper {
    func canMap(_ error: any Error) -> Bool {
        true
    }

    func map(_ error: any Error) -> DomainError {
        .common(.unknown)
    }
}
