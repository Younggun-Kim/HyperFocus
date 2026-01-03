//
//  DeviceDataSource.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import ComposableArchitecture

public struct DeviceDataSource {
    public let getAppVersion: @Sendable () -> String
    public let getBuildNumber: @Sendable () -> String
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
        }
    )
    
    public static var testValue: DeviceDataSource = DeviceDataSource(
        getAppVersion: { "1.0.0" },
        getBuildNumber: { "1" }
    )
    
    public static var previewValue: DeviceDataSource {
        testValue
    }
}

extension DependencyValues {
    public var deviceDataSource: DeviceDataSource {
        get { self[DeviceDataSource.self] }
        set { self[DeviceDataSource.self] = newValue }
    }
}