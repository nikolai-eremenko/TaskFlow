//
//  TodoListPreviewFactory.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import UIKit

enum TodoListPreviewFactory {

    static func make(_ mode: PreviewTodoRepositoryMode) -> UIViewController {

        let logger = PreviewAppLogger()

        let interactor = TodoListInteractor(
            repository: PreviewTodoRepository(mode: mode),
            logger: logger,
            errorMapper: PreviewErrorMapper()
        )

        let router = TodoListRouter(
            logger: logger,
            coordinator: PreviewTodoCoordinator()
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

        let nav = UINavigationController(rootViewController: view)

        return nav
    }
}
