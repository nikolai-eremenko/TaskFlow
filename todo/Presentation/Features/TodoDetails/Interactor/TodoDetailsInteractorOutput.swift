//
//  TodoDetailsInteractorOutput.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

protocol TodoDetailsInteractorOutput: AnyObject {
    func didLoad(todo: Todo)
    func didFail(_ error: DomainError)
}
