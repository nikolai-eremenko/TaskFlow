//
//  VoidResponse.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

/// Represents a "void" response from the backend.
///
/// This is used as a placeholder for endpoints that return no meaningful
/// body content. It allows the generic networking layer to decode
/// all responses uniformly without special-casing void endpoints.
struct VoidResponse: Decodable {}
