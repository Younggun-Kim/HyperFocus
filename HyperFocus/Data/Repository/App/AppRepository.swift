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
    public let checkAppVersion: @Sendable (_ currentVersion: String) async throws -> AppVersionCheckResponse
    public let getDeviceUUID: @Sendable () async throws -> String?
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
        },
        checkAppVersion: { currentVersion in
            @Dependency(\.apiService) var apiService
            return try await apiService.request(
                AppVersionAPI.checkAppVersion(currentVersion: currentVersion),
                responseType: AppVersionCheckResponse.self
            )
        },
        getDeviceUUID: {
            @Dependency(\.deviceDataSource) var deviceDataSource
            return try await deviceDataSource.getDeviceUUID()
        }
    )
    
    public static var testValue: AppRepository = AppRepository(
        getAppVersion: { "1.0.0" },
        getBuildNumber: { "1" },
        checkAppVersion: { _ in AppVersionCheckResponse.mock },
        getDeviceUUID: { nil as String?}
    )
}

extension DependencyValues {
    public var appRepository: AppRepository {
        get { self[AppRepository.self] }
        set { self[AppRepository.self] = newValue }
    }
}
