//
//  SceneDelegate.swift
//  todo
//
//  Created by Nikolai Eremenko on 14.04.2026.
//

import Swinject
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        window.tintColor = .systemYellow

        let splashViewController = SplashScreenViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()

        let diContainer = AppDIContainer(window: window)
        let resolver = diContainer.resolver
        let logger = resolver.resolve(AppLogger.self)!
        let navigationController = UINavigationController()
        let todoListAssembly = TodoListAssembly(resolver: resolver)
        let todoDetailsAssembly = TodoDetailsAssembly(resolver: resolver)

        let todoCoordinator = TodoCoordinator(
            navigationController: navigationController,
            logger: logger,
            todoListAssembly: todoListAssembly,
            todoDetailsAssembly: todoDetailsAssembly
        )

        let appCoordinator = AppCoordinator(
            window: window,
            todoCoordinator: todoCoordinator,
            logger: logger
        )

        logger.debug("App started", category: .lifecycle)

        self.coordinator = appCoordinator

        appCoordinator.start()
    }
}
