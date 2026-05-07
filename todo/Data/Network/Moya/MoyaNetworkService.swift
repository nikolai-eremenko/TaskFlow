//
//  MoyaNetworkService.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation
import Moya

final class MoyaNetworkService: NetworkService {

    // MARK: - Private Properties

    private let provider: MoyaProvider<MultiTarget>
    private let httpStatusMapper: HTTPStatusCodeMapper
    private let urlErrorMapper: URLErrorMapper
    private let logger: AppLogger

    // MARK: - Initializers

    init(
        provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(),
        httpStatusMapper: HTTPStatusCodeMapper,
        urlErrorMapper: URLErrorMapper,
        logger: AppLogger
    ) {
        self.provider = provider
        self.httpStatusMapper = httpStatusMapper
        self.urlErrorMapper = urlErrorMapper
        self.logger = logger
    }

    // MARK: - Public Methods

    func performRequest<T: Decodable>(
        _ request: AppTarget,
        traceId: UUID
    ) async throws -> T {
        let target = try await makeTarget(request, traceId: traceId)
        let start = Date()
        var metadata = LogMetadataBuilder.from(request)
        let category: LogCategory = .network

        logger.debug(
            "Request started",
            category: category,
            metadata: metadata.build(),
            traceId: traceId
        )

        do {
            let response = try await provider.asyncRequestResponse(target)
            let result = try response.decode(T.self, using: AppJSONCoding.decoder)
            let duration = Date().timeIntervalSince(start)

            metadata.statusCode(response.statusCode)
            metadata.responseSize(response.data.count)
            metadata.duration(duration)

            logger.debug(
                "Request succeeded",
                category: category,
                metadata: metadata.build(),
                traceId: traceId
            )

            return result

        } catch {
            let duration = Date().timeIntervalSince(start)
            let coreError = map(error)

            metadata.duration(duration)
            metadata.statusCode(coreError.statusCode)

            logger.logError(
                coreError,
                category: category,
                metadata: metadata.build(),
                traceId: traceId
            )

            throw coreError
        }
    }

    func performVoidRequest(_ request: AppTarget, traceId: UUID) async throws {
        let target: MultiTarget
        let start = Date()
        let category: LogCategory = .network

        target = MultiTarget(request)

        var metadata = LogMetadataBuilder.from(request)

        logger.debug("Request started", category: category, metadata: metadata.build(), traceId: traceId)

        do {
            let response = try await provider.asyncRequestResponse(target)
            _ = try response.decode(VoidResponse.self)

            let duration = Date().timeIntervalSince(start)

            metadata.statusCode(response.statusCode)
            metadata.responseSize(response.data.count)
            metadata.duration(duration)

            logger.debug(
                "Void request succeeded",
                category: category,
                metadata: metadata.build(),
                traceId: traceId
            )

        } catch {
            let duration = Date().timeIntervalSince(start)
            let coreError = map(error)

            metadata.duration(duration)
            metadata.statusCode(coreError.statusCode)
            logger.logError(coreError, category: category, metadata: metadata.build(), traceId: traceId)

            throw coreError
        }
    }

    // MARK: - Private Methods

    private func makeTarget(_ request: AppTarget, traceId: UUID) async throws -> MultiTarget {
        MultiTarget(request)
    }

    // MARK: - Mappers

    /// Maps a `Error` into `CoreError`.
    ///
    /// Centralizing error mapping ensures consistent handling of network
    /// errors and allows the app to react to specific cases like 401 Unauthorized
    /// or decoding failures.
    ///
    /// - Parameter error: The `MoyaError` returned by the provider
    /// - Returns: Corresponding `DataError`
    private func map(_ error: Error) -> CoreError {

        if let coreError = error as? CoreError {
            return coreError
        }

        if let moyaError = error as? MoyaError {
            return mapMoya(moyaError)
        }

        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }

        if let decodingError = error as? DecodingError {
            return .networkService(.decodingFailed(underlying: decodingError, data: nil))
        }

        return .networkService(.underlying(error))
    }

    // swiftlint:disable cyclomatic_complexity
    private func mapMoya(_ error: MoyaError) -> CoreError {
        switch error {

        case .statusCode(let response):
            return .networkService(
                httpStatusMapper.map(
                    statusCode: response.statusCode,
                    data: response.data
                )
            )

        case .objectMapping(let decodingError, let response):
            return .networkService(.decodingFailed(underlying: decodingError, data: response.data))

        case .jsonMapping(let response):
            return .networkService(.decodingFailed(underlying: error, data: response.data))

        case .stringMapping(let response):
            return .networkService(.decodingFailed(underlying: error, data: response.data))

        case .requestMapping(let message):
            return .networkService(.requestMappingFailed(underlying: NSError(
                domain: "MoyaRequestMapping",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: message]
            )))

        case .parameterEncoding(let encodingError):
            return .networkService(.parameterEncodingFailed(underlying: encodingError))

        case .underlying(let underlyingError, let response):
            if let urlError = underlyingError as? URLError {
                return mapURLError(urlError)
            }

            if let response = response {
                return .networkService(
                    httpStatusMapper.map(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                )
            }

            return .networkService(.underlying(underlyingError))

        case .encodableMapping(let error):
            return .networkService(.parameterEncodingFailed(underlying: error))

        case .imageMapping(let response):
            return .networkService(.client(statusCode: response.statusCode, data: response.data))
        }
    }
    // swiftlint:enable cyclomatic_complexity

    private func mapURLError(_ error: URLError) -> CoreError {
        return .networkService(urlErrorMapper.map(error))
    }
}
