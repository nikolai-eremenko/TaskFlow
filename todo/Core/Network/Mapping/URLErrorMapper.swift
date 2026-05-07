//
//  URLErrorMapper.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Foundation

protocol URLErrorMapper {
    func map(_ error: URLError) -> NetworkServiceError
}
