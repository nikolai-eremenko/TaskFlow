//
//  CoreError.swift
//  
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum CoreError: Error {
    case network(NetworkServiceError)
    case persistence(CoreDataStorageError)
    case voiceInput(VoiceInputServiceError)

    var statusCode: Int? {
        switch self {
        case .network(let error):           return error.statusCode
        default:                            return nil
        }
    }
}

extension CoreError: LocalizedError {

    var errorDescription: String? {
        switch self {

        case .network(let error):
            return error.localizedDescription

        case .persistence(let error):
            return error.localizedDescription

        case .voiceInput(let error):
            return error.localizedDescription
        }
    }
}

extension CoreError: LogLevelProvider {
    var logLevel: LogLevel {
        switch self {
        case .network(let error):           return error.logLevel
        case .persistence(let error):       return error.logLevel
        case .voiceInput(let error):        return error.logLevel
        }
    }
}
