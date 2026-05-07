//
//  TodoDetailsViewInput.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

protocol TodoDetailsViewInput: AnyObject {
    func display(todo: Todo)
    func displayCreateState()
    func setSaveEnabled(_ isEnabled: Bool)
    func showError(message: String)
}
