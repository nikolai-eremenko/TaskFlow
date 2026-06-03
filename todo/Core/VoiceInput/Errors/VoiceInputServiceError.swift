//
//  VoiceInputServiceError.swift
//  todo
//
//  Created by Nikolai Eremenko on 11.05.2026.
//

import Foundation

enum VoiceInputServiceError: Error {
    case speechRecognitionDenied
    case microphoneDenied
    case speechRecognitionRestricted
    case recognizerUnavailable(languageCode: String)
    case audioSessionFailed
    case audioEngineFailed
    case recognitionFailed
}

extension VoiceInputServiceError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {

        case .speechRecognitionDenied, .microphoneDenied, .speechRecognitionRestricted, .recognizerUnavailable:
            return .info

        case .recognitionFailed:
            return .error

        case .audioSessionFailed, .audioEngineFailed:
            return .critical
        }
    }
}
