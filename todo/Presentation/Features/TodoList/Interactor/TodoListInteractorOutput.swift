//
//  TodoListInteractorOutput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoListInteractorOutput: AnyObject {

    func didReceiveChange(_ change: TodoChange)

    /// Notifies the presenter that an operation in the interactor failed.
    ///
    /// This method is used for propagating domain-level errors (e.g. storage
    /// failure, network error, decoding issue) to the presentation layer.
    ///
    /// The presenter is responsible for mapping this error into a user-facing
    /// representation (e.g. alert, banner, toast).
    ///
    /// - Parameter error: A domain-level error describing the failure.
    func didFail(_ error: DomainError)
}
