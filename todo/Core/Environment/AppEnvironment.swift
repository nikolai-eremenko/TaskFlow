//
//  AppEnvironment.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

enum AppEnvironment: String {
    /// Local mock environment for development without backend dependencies.
    case mock

    /// Staging environment for testing pre-production features.
    case staging

    /// Development environment for active development with a live backend.
    case development

    /// Production environment for live users.
    case production

    var configuration: EnvironmentConfiguration {
        switch self {

        case .mock:
            return .init(
                baseURL: AppEnvironment.makeURL("https://sample.local"),
                useStubbedProvider: true,
                logLevel: .debug,
                loggerFactories: [
                    XcodeConsoleLoggerFactory()
                ]
            )

        case .staging:
            return .init(
                baseURL: AppEnvironment.makeURL("https://c9358349-e9c5-46c7-b737-505a935190ca.mock.pstmn.io"),
                useStubbedProvider: false,
                logLevel: .debug,
                loggerFactories: [
                    XcodeConsoleLoggerFactory()
                ]
            )

        case .development:
            return .init(
                baseURL: AppEnvironment.makeURL("https://dummyjson.com"),
                useStubbedProvider: false,
                logLevel: .debug,
                loggerFactories: [
                    XcodeConsoleLoggerFactory()
                ]
            )

        case .production:
            return .init(
                baseURL: AppEnvironment.makeURL("https://dummyjson.com"),
                useStubbedProvider: false,
                logLevel: .error,
                loggerFactories: []
            )
        }
    }

    // MARK: - Initialization

    /// Creates an `AppEnvironment` from the Info.plist key `APP_ENV`.
    ///
    /// If the key is missing or invalid, it defaults to `.production` and logs a warning.
    ///
    /// - Parameter logger: Optional logger for reporting fallback to production.
    /// - Returns: The corresponding `AppEnvironment`.
    static func fromPlist() -> AppEnvironment {
        guard let envString = Bundle.main.object(forInfoDictionaryKey: "APP_ENV") as? String,
              let env = AppEnvironment(rawValue: envString) else {
            return .production
        }

        return env
    }

    // MARK: - Private Helpers

    /// Safely creates a URL from a string, triggering a fatal error if the string is invalid.
    ///
    /// - Parameter urlString: The URL string to convert.
    /// - Returns: A valid `URL`.
    private static func makeURL(_ urlString: String) -> URL {
        guard let url = URL(string: urlString) else {
            fatalError("Error: Invalid URL string: \(urlString)")
        }

        return url
    }
}
