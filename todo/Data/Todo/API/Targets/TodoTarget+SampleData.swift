//
//  TodoTarget+SampleData.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

extension TodoTarget {

    var sampleData: Data {
        switch self {
        case .todos:
            guard
                let url = Bundle.main.url(forResource: "todo_sample", withExtension: "json"),
                let data = try? Data(contentsOf: url)
            else {
                return Data()
            }

            return data
        }
    }
}
