//
//  CoreErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

final class CoreErrorMapper: ErrorMapping {

    // MARK: - Public Methods

    func map(_ error: CoreError) -> DomainError {
        switch error {

        case .network(let error):                               return mapNetwork(error)
        case .persistence(let error):                           return mapStorage(error)
        case .voiceInput(let error):                            return mapVoiceInput(error)
        }
    }

    // swiftlint:disable cyclomatic_complexity
    private func mapNetwork(_ error: NetworkServiceError) -> DomainError {
        switch error {

        case .unauthorized:                                     return .server(.unauthorized)
        case .forbidden:                                        return .server(.forbidden)
        case .notFound:                                         return .server(.notFound)
        case .tooManyRequests:                                  return .server(.tooManyRequests)

        case .client:                                           return .server(.clientError)
        case .server:                                           return .server(.serverError)

        case .noInternet:                                       return .connection(.noInternet)
        case .timeout:                                          return .connection(.timeout)
        case .networkConnectionLost:                            return .connection(.connectionLost)
        case .cannotFindHost:                                   return .connection(.cannotFindHost)
        case .cancelled:                                        return .common(.cancelled)

        case .decodingFailed:                                   return .server(.decodingFailed)

        case .requestMappingFailed, .parameterEncodingFailed:   return .common(.unknown)
        case .underlying:                                       return .common(.unknown)
        }
    }
    // swiftlint:enable cyclomatic_complexity

    private func mapStorage(_ error: CoreDataStorageError) -> DomainError {
        switch error {
        case .saveFailed:                                       return .storage(.failure)
        case .fetchFailed:                                      return .storage(.failure)
        case .contextExecutionFailed:                           return .storage(.failure)
        case .storeLoadFailed:                                  return .storage(.unavailable)
        case .notFound:                                         return .storage(.failure)
        }
    }

    private func mapVoiceInput(_ error: VoiceInputServiceError) -> DomainError {
        switch error {
        case .speechRecognitionDenied:                          return .voiceInput(.speechRecognitionDenied)
        case .microphoneDenied:                                 return .voiceInput(.microphoneDenied)
        case .speechRecognitionRestricted:                      return .voiceInput(.speechRecognitionRestricted)
        case .recognizerUnavailable:                            return .voiceInput(.recognizerUnavailable)
        case .audioSessionFailed:                               return .voiceInput(.audioUnavailable)
        case .audioEngineFailed:                                return .voiceInput(.audioUnavailable)
        case .recognitionFailed:                                return .voiceInput(.recognitionFailed)
        }
    }
}
