//
//  TodoCoordinator.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import UIKit

final class TodoCoordinator: TodoCoordinating {

    // MARK: - Private Properties

    private let navigationController: UINavigationController
    private let logger: AppLogger
    private let todoListAssembly: TodoListAssembly
    private let todoDetailsAssembly: TodoDetailsAssembly

    // MARK: - Init

    init(
        navigationController: UINavigationController,
        logger: AppLogger,
        todoListAssembly: TodoListAssembly,
        todoDetailsAssembly: TodoDetailsAssembly
    ) {
        self.navigationController = navigationController
        self.logger = logger
        self.todoListAssembly = todoListAssembly
        self.todoDetailsAssembly = todoDetailsAssembly
    }

    // MARK: - Start

    func start() -> UIViewController {
        logger.debug("TodoCoordinator started", category: .navigation)

        showTodoList()

        return navigationController
    }

    // MARK: - Navigation

    func showTodoList() {
        let viewController = todoListAssembly.makeModule(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)

        logger.debug("Show TodoList", category: .navigation)
    }

    func showCreateTodo(traceId: UUID) {
        let input = TodoDetailsInput(mode: .create)

        let viewController = todoDetailsAssembly.makeModule(
            input: input,
            coordinator: self
        )

        logger.debug("Show create todo", category: .navigation, traceId: traceId)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showEditTodo(todoId: UUID, traceId: UUID) {
        let input = TodoDetailsInput(mode: .edit(id: todoId))

        let viewController = todoDetailsAssembly.makeModule(
            input: input,
            coordinator: self
        )

        logger.debug("Show TodoDetails (edit)", category: .navigation, traceId: traceId)

        navigationController.pushViewController(viewController, animated: true)
    }
}
