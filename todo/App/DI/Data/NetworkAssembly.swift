//
//  NetworkAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 17.04.2026.
//

import Moya
import Swinject
import Foundation

final class NetworkAssembly: Assembly {

    // MARK: - Public methods

    func assemble(container: Container) {

        container.register(MoyaProvider<MultiTarget>.self) { resolver in
            let environment = resolver.resolve(AppEnvironment.self)!
            var plugins: [PluginType] = []

            switch environment {
            case .development, .mock, .staging:
                plugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)))
            default:
                break
            }

            return MoyaProvider<MultiTarget>(
                endpointClosure: self.makeEndpointClosure(environment: environment),
                stubClosure: self.makeStubClosure(environment: environment),
                plugins: plugins
            )
        }
        .inObjectScope(.container)

        container.register(HTTPStatusCodeMapper.self) { _ in
            DefaultHTTPStatusCodeMapper()
        }
        .inObjectScope(.container)

        container.register(URLErrorMapper.self) { _ in
            DefaultURLErrorMapper()
        }
        .inObjectScope(.container)

        container.register(NetworkService.self) {
            MoyaNetworkService(
                provider: $0.resolve(MoyaProvider<MultiTarget>.self)!,
                httpStatusMapper: $0.resolve(HTTPStatusCodeMapper.self)!,
                urlErrorMapper: $0.resolve(URLErrorMapper.self)!,
                logger: $0.resolve(AppLogger.self)!
            )
        }
        .inObjectScope(.container)
    }

    // MARK: - Private methods

    private func makeEndpointClosure(
        environment: AppEnvironment
    ) -> (MultiTarget) -> Endpoint {
        { target in
            let url = environment.configuration.baseURL
                .appendingPathComponent(target.path)
                .absoluteString

            return Endpoint(
                url: url,
                sampleResponseClosure: {
                    .networkResponse(200, target.sampleData)
                },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
    }

    private func makeStubClosure(environment: AppEnvironment) -> (MultiTarget) -> StubBehavior {

        if environment.configuration.useStubbedProvider {
            return { (_: MultiTarget) -> StubBehavior in
                    .immediate
            }
        } else {
            return MoyaProvider.neverStub
        }
    }
}
