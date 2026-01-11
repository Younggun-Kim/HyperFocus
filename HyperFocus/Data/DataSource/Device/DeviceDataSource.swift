//
//  DeviceDataSource.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import ComposableArchitecture
import UIKit

public struct DeviceDataSource {
    public let getAppVersion: @Sendable () -> String
    public let getBuildNumber: @Sendable () -> String
    public let getDeviceUUID: @Sendable () async throws -> String?
    public let getDeviceModel: @Sendable () async throws -> String
    public let getOSVersion: @Sendable () async throws -> String
}

extension DeviceDataSource: DependencyKey {
    public static var liveValue: DeviceDataSource = DeviceDataSource(
        getAppVersion: {
            guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return "Unknown"
            }
            return version
        },
        getBuildNumber: {
            guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
                return "Unknown"
            }
            return buildNumber
        },
        getDeviceUUID: {
            await MainActor.run {
                UIDevice.current.identifierForVendor?.uuidString
            }
        },
        getDeviceModel: {
            await MainActor.run {
                UIDevice.current.model
            }
        },
        getOSVersion: {
            await MainActor.run {
                UIDevice.current.systemVersion
            }
        }
    )
    
    public static var testValue: DeviceDataSource = DeviceDataSource(
        getAppVersion: { "1.0.0" },
        getBuildNumber: { "1" },
        getDeviceUUID: { "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" },
        getDeviceModel: { "iPhone" },
        getOSVersion: { "17.0" }
    )
}

extension DependencyValues {
    public var deviceDataSource: DeviceDataSource {
        get { self[DeviceDataSource.self] }
        set { self[DeviceDataSource.self] = newValue }
    }
}
