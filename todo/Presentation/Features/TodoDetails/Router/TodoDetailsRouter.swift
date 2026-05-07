//
//  TodoDetailsRouter.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import UIKit

final class TodoDetailsRouter {

    weak var viewController: UIViewController?

    private let logger: AppLogger
    private let coordinator: TodoCoordinating

    init(
        logger: AppLogger,
        coordinator: TodoCoordinating
    ) {
        self.logger = logger
        self.coordinator = coordinator
    }
}

// MARK: - TodoDetailsRouting

extension TodoDetailsRouter: TodoDetailsRouting {

    func close() {
        if let navigationController = viewController?.navigationController,
           navigationController.viewControllers.count > 1 {

            navigationController.popViewController(animated: true)

        } else {
            viewController?.dismiss(animated: true)
        }
    }
}
