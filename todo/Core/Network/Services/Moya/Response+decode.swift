//
//  Response+decode.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import Moya

extension Response {

    func decode<T: Decodable>(
        _ type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {

        guard (200...299).contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MoyaError.objectMapping(error, self)
        }
    }
}
