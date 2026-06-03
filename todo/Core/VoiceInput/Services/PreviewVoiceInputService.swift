//
//  PreviewVoiceInputService.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.05.2026.
//

import Foundation

final class PreviewVoiceInputService: VoiceInputService {
    let eventStream: AsyncStream<VoiceInputEvent>

    init() {
        self.eventStream = AsyncStream { _ in }
    }

    func startRecording(languageCode: String, _ traceId: UUID) throws(CoreError) {}
    func stop(_ reason: String = "unknown", _ traceId: UUID) {}
}
