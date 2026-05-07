//
//  WindowAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Swinject
import UIKit

final class WindowAssembly: Assembly {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func assemble(container: Container) {
        container.register(UIWindow.self) { _ in
            self.window
        }.inObjectScope(.container)
    }
}
