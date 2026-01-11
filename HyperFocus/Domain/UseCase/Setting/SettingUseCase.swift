//
//  SettingUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation
import ComposableArchitecture

public struct SettingUseCase {
    public let getSetting: @Sendable () async throws -> SettingEntity?
    public let patchSetting: @Sendable (_ soundEnabled: Bool, _ hapticEnabled: Bool, _ alarmEnabled: Bool) async throws -> SettingEntity?
    public let sendFeedback: @Sendable (_ category: String, _ content: String) async throws -> SettingFeedbackEntity?
}

extension SettingUseCase: DependencyKey {
    public static var liveValue = SettingUseCase(
        getSetting: {
            @Dependency(\.settingRepository) var settingRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            return try await settingRepository.getSetting().data?.toEntity()
        },
        patchSetting: { soundEnabled, hapticEnabled, alarmEnabled in
            @Dependency(\.settingRepository) var settingRepository
            
            let request = SettingRequest(
                soundEnabled: soundEnabled,
                hapticEnabled: hapticEnabled,
                alarmEnabled: alarmEnabled
            )
            
            let response = try await settingRepository.patchSetting(request)
            return response.data?.toEntity()
        },
        sendFeedback: { category, content in
            @Dependency(\.settingRepository) var settingRepository
            @Dependency(\.deviceDataSource) var deviceDataSource
            
            // 디바이스 정보 수집
            let appVersion = deviceDataSource.getAppVersion()
            let deviceModel = try await deviceDataSource.getDeviceModel()
            let osVersion = try await deviceDataSource.getOSVersion()
            
            // FeedbackRequest 생성
            let request = FeedbackRequest(
                category: category,
                content: content,
                appVersion: appVersion,
                deviceModel: deviceModel,
                osVersion: osVersion
            )
            
            let response = try await settingRepository.sendFeedback(request)
            return response.data?.toEntity()
        }
    )
    
    public static var testValue = SettingUseCase(
        getSetting: { SettingEntity.mock },
        patchSetting: { _, _, _ in SettingEntity.mock },
        sendFeedback: { _, _ in SettingFeedbackEntity.mock }
    )
}

extension DependencyValues {
    var settingUseCase: SettingUseCase {
        get { self[SettingUseCase.self] }
        set { self[SettingUseCase.self] = newValue }
    }
}
