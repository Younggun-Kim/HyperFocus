//
//  SettingRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation
import ComposableArchitecture

public struct SettingRepository {
    public let getSetting: @Sendable () async throws -> APIResponse<SettingResponse>
    public let patchSetting: @Sendable (_ request: SettingRequest) async throws -> APIResponse<SettingResponse>
    public let sendFeedback: @Sendable (_ request: FeedbackRequest) async throws -> APIResponse<FeedbackResponse>
}

extension SettingRepository: DependencyKey {
    public static var liveValue = SettingRepository(
        getSetting: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                SettingAPI.getSetting,
                responseType: SettingResponse.self
            )
        },
        patchSetting: { request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                SettingAPI.patchSetting(request),
                responseType: SettingResponse.self
            )
        },
        sendFeedback: { request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                SettingAPI.sendFeedback(request),
                responseType: FeedbackResponse.self
            )
        }
    )
}

extension DependencyValues {
    public var settingRepository: SettingRepository {
        get { self[SettingRepository.self] }
        set { self[SettingRepository.self] = newValue }
    }
}

