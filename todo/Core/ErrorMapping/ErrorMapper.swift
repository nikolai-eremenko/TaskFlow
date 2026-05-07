//
//  ErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

/// A protocol that defines a unified interface for converting any `Error`
/// into a `DomainError`.
///
/// This abstraction allows the application to centralize error translation
/// logic and keep the Domain layer isolated from infrastructure-specific errors.
///
/// Implementations are typically used inside the global error mapping pipeline.
protocol ErrorMapper: AnyObject {

    func canMap(_ error: Error) -> Bool

    /// Converts a given `Error` into a corresponding `DomainError`.
    ///
    /// - Parameter error: The incoming error from any layer (Data, Core, etc.).
    /// - Returns: A mapped `DomainError` representation.
    func map(_ error: Error) -> DomainError
}
