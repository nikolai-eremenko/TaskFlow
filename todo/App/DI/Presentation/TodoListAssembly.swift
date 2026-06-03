//
//  TodoListAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Swinject
import UIKit

final class TodoListAssembly {

    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func makeModule(coordinator: TodoCoordinating) -> UIViewController {
        let logger = resolver.resolve(AppLogger.self)!

        let interactor = TodoListInteractor(
            repository: resolver.resolve(TodoRepository.self)!,
            voiceInputService: resolver.resolve(VoiceInputService.self)!,
            errorMapper: resolver.resolve(ErrorMapping.self)!,
            logger: logger
        )

        let router = TodoListRouter(
            logger: logger,
            coordinator: coordinator
        )

        let presenter = TodoListPresenter(
            interactor: interactor,
            router: router,
            logger: logger
        )

        let view = TodoListViewController(logger: logger)

        view.output = presenter
        presenter.view = view
        interactor.output = presenter
        router.viewController = view

        return view
    }
}
