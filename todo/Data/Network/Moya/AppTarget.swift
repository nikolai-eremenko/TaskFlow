//
//  AppTarget.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Moya

protocol AppTarget: TargetType {
    var requiresAuth: Bool { get }
}

extension AppTarget {

    var requiresAuth: Bool { true }

    func withBearer(_ token: String) -> AuthorizedTarget {
        .authorized(self, token: token)
    }
}
