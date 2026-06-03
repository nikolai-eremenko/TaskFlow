//
//  TodoRemoteService.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoRemoteService {
    func fetchTodos(traceId: UUID) async throws(CoreError) -> TodosResponseDTO
}
