//
//  TodoListInteractorOutput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoListInteractorOutput: AnyObject {

    func didReceiveChange(_ change: TodoChange)
    func didFail(_ error: DomainError)

    func didReceiveVoiceText(_ text: String)
    func didStartVoiceInput()
    func didStopVoiceInput()
    func didFailVoiceInput(_ error: DomainError)
}
