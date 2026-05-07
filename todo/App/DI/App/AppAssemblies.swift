//
//  AppAssemblies.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Swinject
import UIKit

enum AppAssemblies {
    static func all(window: UIWindow) -> [Assembly] {

        return [
            WindowAssembly(window: window)
        ]
    }
}
