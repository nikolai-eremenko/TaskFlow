//
//  VoiceInputError.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.05.2026.
//

import Foundation

enum VoiceInputError: Error {
    case microphoneDenied
    case speechRecognitionDenied
    case speechRecognitionRestricted
    case recognizerUnavailable
    case recognitionFailed
    case audioUnavailable
}

extension VoiceInputError: LogLevelProvider {

    var logLevel: LogLevel {
        switch self {

        case .speechRecognitionDenied, .microphoneDenied, .speechRecognitionRestricted, .recognizerUnavailable:
            return .info

        case .recognitionFailed:
            return .error

        case .audioUnavailable:
            return .critical
        }
    }
}
