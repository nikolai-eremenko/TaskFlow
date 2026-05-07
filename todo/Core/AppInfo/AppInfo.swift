//
//  AppInfo.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

protocol AppInfo {
    var appName: String { get }
    var version: String { get }
    var build: String { get }

    var bundleId: String { get }
    var deviceId: String { get }
    var deviceIdentifier: String { get }
    var systemVersion: String { get }
}
