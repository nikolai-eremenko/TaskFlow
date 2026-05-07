//
//  TodoDetailsViewOutput.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import Foundation

@MainActor
protocol TodoDetailsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String, description: String?)
    func didChange(title: String, description: String?)
}
