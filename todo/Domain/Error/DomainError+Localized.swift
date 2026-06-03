//
//  DomainError+Localized.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import Foundation

extension DomainError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .connection(let error):    return error.errorDescription
        case .server(let error):        return error.errorDescription
        case .storage(let error):       return error.errorDescription
        case .common(let error):        return error.errorDescription
        case .voiceInput(let error):    return error.errorDescription
        }
    }
}

extension ConnectionError: LocalizedError {

    var errorDescription: String? {

        switch self {
        case .noInternet:               return "Нет подключения к интернету"
        case .timeout:                  return "Превышено время ожидания ответа"
        case .connectionLost:           return "Соединение было потеряно"
        case .cannotFindHost:           return "Не удалось найти сервер"
        }
    }
}

extension CommonError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .cancelled:                return "Операция была отменена"
        case .unknown:                  return "Произошла неизвестная ошибка"
        }
    }
}

extension ServerError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .unauthorized:              return "Требуется авторизация"
        case .forbidden:                 return "Доступ запрещён"
        case .notFound:                  return "Ресурс не найден"
        case .conflict:                  return "Конфликт данных"
        case .tooManyRequests:           return "Слишком много запросов. Попробуйте позже"
        case .serverError:               return "Ошибка сервера"
        case .clientError:               return "Ошибка запроса"
        case .decodingFailed:            return "Ошибка обработки данных сервера"
        case .custom:                    return "Ошибка сервера"
        }
    }
}

extension StorageError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .failure:                   return "Не удалось сохранить или загрузить данные"
        case .corruptedData:             return "Данные повреждены. Требуется восстановление"
        case .unavailable:               return "Хранилище недоступно"
        }
    }
}

extension VoiceInputError: LocalizedError {

    var errorDescription: String? {
        switch self {

            // Open Settings + Cancel
        case .microphoneDenied:
            return "Microphone access is disabled."

            // Open Settings + Cancel
        case .speechRecognitionDenied:
            return "Speech recognition is disabled."

            // OK
        case .speechRecognitionRestricted:
            return "This feature is not available on this device or account."

            // OK + Change language
        case .recognizerUnavailable:
            return "Language not supported"

        case .recognitionFailed:             return "Couldn’t recognize speech."

        case .audioUnavailable:               return "Voice input is unavailable."
        }
    }
}
