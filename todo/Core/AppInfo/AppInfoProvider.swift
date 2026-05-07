//
//  AppInfoProvider.swift
//  todo
//
//  Created by Nikolai Eremenko on 16.04.2026.
//

import UIKit

final class AppInfoProvider: AppInfo {

    let appName: String
    let version: String
    let build: String
    let bundleId: String
    let deviceId: String
    let deviceIdentifier: String
    let systemVersion: String

    init() {
        self.appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"

        self.version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "N/A"

        self.build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A"
        self.bundleId = Bundle.main.bundleIdentifier ?? "unknown"
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        self.deviceIdentifier = Self.deviceIdentifier()
        self.systemVersion = UIDevice.current.systemVersion
    }

    // MARK: - Private Methods

    private static func deviceIdentifier() -> String {
        var systemInfo = utsname()

        uname(&systemInfo)

        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }
}
