//
//  AppDIContainer.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Swinject
import UIKit

final class AppDIContainer {

    let assembler: Assembler

    var resolver: Resolver { assembler.resolver }

    // MARK: - Init

    init(window: UIWindow) {
        assembler = Assembler(
            [
                AppAssemblies.all(window: window),
                CoreAssemblies.all(),
                DataAssemblies.all()
            ].flatMap { $0 }
        )
    }
}
