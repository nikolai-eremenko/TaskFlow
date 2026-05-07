//
//  TodoListViewOutput.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol TodoListViewOutput: AnyObject {
    func viewDidLoad(traceId: UUID)
    func didSelectEdit(id: UUID)
    func didSelectShare(id: UUID)
    func didSelectDelete(id: UUID, traceId: UUID)
    func didSearch(text: String)
    func didTapCreate(traceId: UUID)
    func didTapCheckbox(id: UUID)
}
