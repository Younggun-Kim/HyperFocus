//
//  AppRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import ComposableArchitecture

public struct AppRepository {
    public let getAppVersion: @Sendable () -> String
    public let getBuildNumber: @Sendable () -> String
}

extension AppRepository: DependencyKey {
    public static var liveValue: AppRepository = AppRepository(
        getAppVersion: {
            @Dependency(\.deviceDataSource) var deviceDataSource
            return deviceDataSource.getAppVersion()
        },
        getBuildNumber: {
            @Dependency(\.deviceDataSource) var deviceDataSource
            return deviceDataSource.getBuildNumber()
        }
    )
    
    public static var testValue: AppRepository = AppRepository(
        getAppVersion: { "1.0.0" },
        getBuildNumber: { "1" }
    )
    
    public static var previewValue: AppRepository {
        testValue
    }
}

extension DependencyValues {
    public var appRepository: AppRepository {
        get { self[AppRepository.self] }
        set { self[AppRepository.self] = newValue }
    }
}