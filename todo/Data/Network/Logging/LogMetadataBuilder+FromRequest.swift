//
//  LogMetadataBuilder+FromRequest.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import Moya
import Alamofire

extension LogMetadataBuilder {

    static func from(_ request: AppTarget) -> Self {
        var meta = Self()

        meta.method(request.method.rawValue)
        meta.target("\(Swift.type(of: request)).\(request.path)")

        return meta
    }
}
