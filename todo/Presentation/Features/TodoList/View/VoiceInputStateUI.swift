//
//  VoiceInputStateUI.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.05.2026.
//

import Foundation

enum VoiceInputStateUI {
    case idle
    case recording
    case processing
    case unavailable
    case error(String)
}
