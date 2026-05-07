//
//  AppJSONCoding.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum AppJSONCoding {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(AppDateFormatters.serverDateOnly)
        return decoder
    }()

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(AppDateFormatters.serverDateOnly)
        return encoder
    }()
}
