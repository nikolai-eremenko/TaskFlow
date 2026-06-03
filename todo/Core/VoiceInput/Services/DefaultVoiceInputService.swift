//
//  DefaultVoiceInputService.swift
//  todo
//
//  Created by Nikolai Eremenko on 11.05.2026.
//

import AVFoundation
import Foundation
import Speech

enum VoiceInputEvent {
    case text(String)
    case didStart
    case didStop
    case error(CoreError)
}

final class DefaultVoiceInputService: NSObject, VoiceInputService {

    // MARK: - Public Properties

    let eventStream: AsyncStream<VoiceInputEvent>

    // MARK: - Private Properties

    private enum State {
        case idle
        case starting
        case running
        case stopping
    }

    private let audioEngine = AVAudioEngine()

    private var continuation: AsyncStream<VoiceInputEvent>.Continuation?
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var languageCode: String?
    private var state: State = .idle

    private let stateLock = NSLock()
    private let logger: AppLogger

    // MARK: - Initializers

    init(logger: AppLogger) {
        self.logger = logger

        var cont: AsyncStream<VoiceInputEvent>.Continuation?

        self.eventStream = AsyncStream { continuation in
            cont = continuation
        }

        self.continuation = cont

        super.init()
    }

    deinit {
        continuation?.finish()
    }

    // MARK: - Public Methods

    func startRecording(languageCode: String, _ traceId: UUID) throws(CoreError) {

        stateLock.lock()
        guard state == .idle else {
            stateLock.unlock()
            return
        }
        state = .starting
        stateLock.unlock()

        emit(.didStart)

        self.languageCode = languageCode
        request = SFSpeechAudioBufferRecognitionRequest()

        Task {
            await Task.yield()
            try await Task.sleep(nanoseconds: 150_000_000)

            do {
                try await requestPermissions(traceId)
                try setupAudioSession(traceId)
                try setupRecognizer(languageCode: languageCode, traceId)
                try startAudioEngine(traceId)
                startRecognitionLoop(traceId)

                stateLock.lock()
                state = .running
                stateLock.unlock()

            } catch {
                let coreError = mapError(error)
                emit(.error(coreError))
                stop("recognition error", traceId)
            }
        }
    }

    func stop(_ reason: String = "unknown", _ traceId: UUID) {
        stateLock.lock()

        guard state != .stopping else {
            stateLock.unlock()
            return
        }
        state = .stopping
        stateLock.unlock()

//        logger.debug("Stop recording", category: .feature, traceId: traceId)
        logger.debug("Stop recording: \(reason)", category: .feature, traceId: traceId)

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        request?.endAudio()
        request = nil

        task?.cancel()
        task = nil

        speechRecognizer = nil

        stateLock.lock()
        state = .idle
        stateLock.unlock()

        emit(.didStop)
    }

    // MARK: - Private Methods

    func requestPermissions(_ traceId: UUID) async throws {

        let speechStatus = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status)
            }
        }

        guard speechStatus == .authorized else {
            throw CoreError.voiceInput(.speechRecognitionDenied)
        }

        let currentMicStatus = AVAudioApplication.shared.recordPermission

        if currentMicStatus == .undetermined {

            let granted = await withCheckedContinuation { cont in
                AVAudioApplication.requestRecordPermission { granted in
                    cont.resume(returning: granted)
                }
            }

            guard granted else {
                throw CoreError.voiceInput(.microphoneDenied)
            }
        }

        guard AVAudioApplication.shared.recordPermission == .granted else {
            throw CoreError.voiceInput(.microphoneDenied)
        }
    }

    private func setupAudioSession(_ traceId: UUID) throws {
        logger.debug("Setup audio session", category: .feature)

        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            logger.debug("Audio session setup completed", category: .feature, traceId: traceId)

        } catch {
            throw error
        }
    }

    private func setupRecognizer(languageCode: String, _ traceId: UUID) throws {
        logger.debug("Setup recognizer", category: .feature, traceId: traceId)

        let locale = Locale(identifier: languageCode)

        guard SFSpeechRecognizer.supportedLocales().contains(locale) else {
            let error = CoreError.voiceInput(.recognizerUnavailable(languageCode: languageCode))
            logger.logError(error, category: .feature, traceId: traceId)
            throw error
        }

        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            let error = CoreError.voiceInput(.recognizerUnavailable(languageCode: languageCode))
            logger.logError(error, category: .feature, traceId: traceId)
            throw error
        }

        self.speechRecognizer = recognizer

        logger.debug("Recognizer setup completed", category: .feature, traceId: traceId)
    }

    private func startAudioEngine(_ traceId: UUID) throws {
        logger.debug("Start audio engine", category: .feature, traceId: traceId)

        let inputNode = audioEngine.inputNode

        inputNode.removeTap(onBus: 0)

        let format = inputNode.outputFormat(forBus: 0)

        guard format.sampleRate > 0 else {
            let error = CoreError.voiceInput(.audioEngineFailed)
            logger.logError(error, category: .feature, traceId: traceId)
            throw error
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard
                let self,
                let request = self.request
            else {
                self?.logger.debug("Request is nil", category: .feature, traceId: traceId)
                return
            }

            request.append(buffer)
        }

        audioEngine.prepare()

        try audioEngine.start()

        logger.debug("Audio engine started", category: .feature, traceId: traceId)
    }

    private func startRecognitionLoop(_ traceId: UUID) {
        logger.debug("Start recognition loop", category: .feature, traceId: traceId)

        guard
            let recognizer = speechRecognizer,
            let request = request
        else {
            logger.debug("Recognizer or request is nil", category: .feature, traceId: traceId)
            return
        }

        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false

        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }

            guard self.state == .running else { return }

            if let result {
                self.emit(.text(result.bestTranscription.formattedString))
            }

            if let error {
                let coreError = self.mapError(error)
                self.emit(.error(coreError))
                self.stop("recognition error", traceId)
                return
            }

            if result?.isFinal == true {
                self.stop("final result", traceId)
            }
        }
    }

    // MARK: - Helpers

    private func emit(_ event: VoiceInputEvent) {
        continuation?.yield(event)
    }

    private func resetEngine(_ traceId: UUID) {
        audioEngine.stop()
        audioEngine.reset()

        logger.debug("Reset audio engine", category: .feature, traceId: traceId)
    }

    private func mapError(_ error: Error) -> CoreError {
        let nsError = error as NSError

        if nsError.domain == "kAFAssistantErrorDomain" || nsError.domain == "kSFSpeechRecognizerErrorDomain" {
            switch nsError.code {
            case 1:     return .voiceInput(.speechRecognitionDenied)
            case 5:     return .voiceInput(.speechRecognitionRestricted)
            case 1101:  return .voiceInput(.recognizerUnavailable(languageCode: languageCode ?? "unknown"))
            default:    return .voiceInput(.recognitionFailed)
            }
        }

        if nsError.domain == NSOSStatusErrorDomain || nsError.domain == "com.apple.avfaudio" {
            switch nsError.code {
            case -50:       return .voiceInput(.audioSessionFailed)
            case -10851:    return .voiceInput(.audioSessionFailed)
            case -11819:    return .voiceInput(.audioSessionFailed)
            default:        return .voiceInput(.audioEngineFailed)
            }
        }

        return .voiceInput(.recognitionFailed)
    }
}
