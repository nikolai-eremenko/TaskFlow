//
//  TodoDetailsAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Swinject
import UIKit

final class TodoDetailsAssembly {

    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func makeModule(
        input: TodoDetailsInput,
        coordinator: TodoCoordinating
    ) -> UIViewController {

        let logger = resolver.resolve(AppLogger.self)!
        let repository = resolver.resolve(TodoRepository.self)!

        let interactor = TodoDetailsInteractor(
            repository: repository,
            logger: logger
        )

        let router = TodoDetailsRouter(
            logger: logger,
            coordinator: coordinator
        )

        let presenter = TodoDetailsPresenter(
            input: input,
            logger: logger
        )

        let view = TodoDetailsViewController()

        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }
}
