//
//  LogCategory.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

enum LogCategory: String, CaseIterable {

    // MARK: - Architecture Layers

    case userInterface = "UI"
    case navigation = "Navigation"

    /// App/screen lifecycle events
    case lifecycle = "Lifecycle"

    // MARK: - Infrastructure

    case location = "Location"
    case network = "Network"

    /// API requests, responses
    case api = "API"

    /// Database, storage, cache
    case persistence = "Persistence"

    // MARK: - Business Logic

    /// Core business logic
    case domain = "Domain"

    /// Feature-specific logic
    case feature = "Feature"

    // MARK: - Resources

    case debug
    case testing
}

extension LogCategory {

    var emoji: String {
        switch self {
        case .userInterface:            return "🖥"
        case .navigation:               return "🧭"
        case .lifecycle:                return "🔄"
        case .location:                 return "📍"
        case .network:                  return "🌐"
        case .api:                      return "📡"
        case .persistence:              return "💾"
        case .domain:                   return "🧠"
        case .feature:                  return "🧩"
        case .debug:                    return "🐞"
        case .testing:                  return "🧪"
        }
    }
}
