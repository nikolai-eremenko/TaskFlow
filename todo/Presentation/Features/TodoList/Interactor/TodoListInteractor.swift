//
//  TaskListInteractor.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import Foundation

final class TodoListInteractor {

    var output: TodoListInteractorOutput?

    private var observingTask: Task<Void, Never>?
    private var voiceInputTask: Task<Void, Never>?

    private let repository: TodoRepository
    private let voiceInputService: VoiceInputService
    private let errorMapper: ErrorMapping
    private let logger: AppLogger

    // MARK: - Init

    init(
        repository: TodoRepository,
        voiceInputService: VoiceInputService,
        errorMapper: ErrorMapping,
        logger: AppLogger
    ) {
        self.repository = repository
        self.voiceInputService = voiceInputService
        self.errorMapper = errorMapper
        self.logger = logger
    }

    // MARK: - Private Methods

    private func handleVoiceEvent(_ event: VoiceInputEvent) {
        switch event {

        case .didStart:
            output?.didStartVoiceInput()

        case .didStop:
            output?.didStopVoiceInput()

        case .text(let text):
            output?.didReceiveVoiceText(text)

        case .error(let error):
            let domainError = errorMapper.map(error)
            output?.didFailVoiceInput(domainError)
        }
    }
}

extension TodoListInteractor: TodoListInteractorInput {

    func start(traceId: UUID) {
        logger.debug("Start observing todos changes", category: .feature, traceId: traceId)

        observingTask?.cancel()

        observingTask = Task { [weak self] in
            guard let self else { return }

            for await change in repository.observe(traceId: traceId) {
                await MainActor.run {
                    self.output?.didReceiveChange(change)
                }
            }
        }
    }

    func loadInitialData(traceId: UUID) async {
        logger.debug("Start initial bootstrap", category: .feature, traceId: traceId)

        do {
            try await repository.bootstrapIfNeeded(traceId: traceId)

            logger.debug(
                "Initial bootstrap completed",
                category: .feature,
                traceId: traceId
            )

        } catch {
            await MainActor.run {
                output?.didFail(error)
            }
        }
    }

    func deleteTodo(id: UUID, traceId: UUID) async {
        logger.debug("Delete todo", category: .feature, traceId: traceId)

        do {
            try await repository.delete(id: id, traceId: traceId)

        } catch {
            await MainActor.run {
                output?.didFail(error)
            }
        }
    }

    func toggleCompletion(id: UUID, traceId: UUID) async {

        do {
            try await repository.toggleTodoCompletion(id: id, traceId: traceId)

            logger.debug(
                "Toggle todo completion finished successfully",
                category: .feature,
                traceId: traceId
            )

        } catch {
            await MainActor.run {
                output?.didFail(error)
            }
        }
    }

    func searchTodos(text: String, traceId: UUID) async {
        repository.search(text: text, traceId: traceId)
    }

    func startVoiceInput(languageCode: String, _ traceId: UUID) {
        logger.debug("Voice input started", category: .feature, traceId: traceId)

        voiceInputTask?.cancel()

        do {
            try voiceInputService.startRecording(languageCode: languageCode, traceId)

        } catch {
            let domainError = errorMapper.map(error)
            logger.logError(domainError, category: .feature, traceId: traceId)
            output?.didFailVoiceInput(domainError)
            return
        }

        voiceInputTask = Task { [weak self] in
            guard let self else { return }

            for await event in self.voiceInputService.eventStream {
                await MainActor.run {
                    self.handleVoiceEvent(event)
                }
            }
        }
    }

    func stopVoiceInput(_ traceId: UUID) {
        voiceInputService.stop("Interactor", traceId)
        voiceInputTask?.cancel()
        voiceInputTask = nil
    }
}
