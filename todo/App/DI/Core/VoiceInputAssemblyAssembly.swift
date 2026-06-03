//
//  VoiceInputAssemblyAssembly.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.05.2026.
//

import Swinject

final class VoiceInputAssemblyAssembly: Assembly {

    func assemble(container: Container) {

        container.register(VoiceInputService.self) { resolver in
            DefaultVoiceInputService(
                logger: resolver.resolve(AppLogger.self)!
            )
        }
    }
}
