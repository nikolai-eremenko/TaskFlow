//
//  VoiceInputService.swift
//  todo
//
//  Created by Nikolai Eremenko on 11.05.2026.
//

import Foundation

protocol VoiceInputService {
    var eventStream: AsyncStream<VoiceInputEvent> { get }

    func startRecording(languageCode: String, _ traceId: UUID) throws(CoreError)
    func stop(_ reason: String, _ traceId: UUID)
}
