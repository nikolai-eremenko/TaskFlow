//
//  AppCoordinator.swift
//  todo
//
//  Created by Nikolai Eremenko on 14.04.2026.
//

import UIKit

final class AppCoordinator {

    // MARK: - Private Properties

    private let window: UIWindow
    private let todoCoordinator: TodoCoordinator
    private let logger: AppLogger

    // MARK: - Init

    init(
        window: UIWindow,
        todoCoordinator: TodoCoordinator,
        logger: AppLogger
    ) {
        self.window = window
        self.todoCoordinator = todoCoordinator
        self.logger = logger
    }

    func start() {
        logger.debug("AppCoordinator started", category: .navigation)
        showTodoFlow()
    }

    // MARK: - Private methods

    private func showTodoFlow() {
        logger.debug("Switching to Todo flow", category: .navigation)

        let root = todoCoordinator.start()
        setRoot(root)
    }

    private func setRoot(_ viewController: UIViewController) {

        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: {
                self.window.rootViewController = viewController
            }
        )
    }
}
