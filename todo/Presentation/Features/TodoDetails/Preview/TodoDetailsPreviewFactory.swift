//
//  TodoDetailsPreviewFactory.swift
//  todo
//
//  Created by Nikolai Eremenko on 07.05.2026.
//

import UIKit

enum TodoDetailsPreviewScenario {
    case create
    case edit
    case error
}

enum TodoDetailsPreviewFactory {

    static func make(_ scenario: TodoDetailsPreviewScenario) -> UIViewController {

        let logger = PreviewAppLogger()

        let repositoryMode: PreviewTodoRepositoryMode = {
            switch scenario {
            case .create, .edit:    return .loaded
            case .error:            return .error
            }
        }()

        let interactor = TodoDetailsInteractor(
            repository: PreviewTodoRepository(mode: repositoryMode),
            logger: logger
        )

        let router = TodoDetailsRouter(
            logger: logger,
            coordinator: PreviewTodoCoordinator()
        )

        let input: TodoDetailsInput = {
            switch scenario {
            case .create:           return TodoDetailsInput(mode: .create)
            case .edit, .error:     return TodoDetailsInput(mode: .edit(id: UUID()))
            }
        }()

        let presenter = TodoDetailsPresenter(input: input, logger: logger)
        let view = TodoDetailsViewController()

        view.output = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        let navigationController = UINavigationController(rootViewController: view)

        return navigationController
    }
}
