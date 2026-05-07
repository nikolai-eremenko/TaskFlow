//
//  TaskListRouter.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import UIKit

final class TodoListRouter {
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

extension TodoListRouter: TodoListRouterInput {

    func openEditTodo(id: UUID, traceId: UUID) {
        logger.debug("Show TodoDetails (edit)", category: .navigation, traceId: traceId)
        coordinator.showEditTodo(todoId: id, traceId: traceId)
    }

    func openCreateTodo(traceId: UUID) {
        logger.debug("Show TodoDetails (create)", category: .navigation, traceId: traceId)
        coordinator.showCreateTodo(traceId: traceId)
    }

    func shareTodo(item: TodoShareItem, traceId: UUID) {
        guard let viewController = viewController else { return }

        logger.debug("Show share todo", category: .navigation, traceId: traceId)

        var items: [Any] = [
            "\(item.title)\n\(item.description ?? "")"
        ]

        if let link = item.deepLink {
            items.append(link)
        }

        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )

        viewController.present(activityVC, animated: true)
    }
}
