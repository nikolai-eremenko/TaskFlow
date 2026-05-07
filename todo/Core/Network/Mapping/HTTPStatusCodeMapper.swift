//
//  HTTPStatusCodeMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol HTTPStatusCodeMapper {
    func map(statusCode: Int, data: Data?) -> NetworkServiceError
}
