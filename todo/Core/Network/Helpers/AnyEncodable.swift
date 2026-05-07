//
//  AnyEncodable.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

struct AnyEncodable: Encodable {

    private let encodeClosure: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        self.encodeClosure = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
