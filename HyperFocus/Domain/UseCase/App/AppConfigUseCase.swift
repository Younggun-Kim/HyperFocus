//
//  AppConfigUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import ComposableArchitecture

public struct AppConfigUseCase {
    public let needAppUpdate: @Sendable () async throws -> VersionUpdateType
}

extension AppConfigUseCase: DependencyKey {
    public static var liveValue = AppConfigUseCase(
        needAppUpdate: {
            @Dependency(\.appRepository) var appRepository
            
            let currentVersion = appRepository.getAppVersion()
            let response = try await appRepository.checkAppVersion(currentVersion)
            
            guard let updateTypeRaw = response.data?.updateType else {
                return .none
            }
            
            return VersionUpdateType(version: updateTypeRaw) ?? .none
        }
    )
    
    // Preview용 기본값
    public static var previewValue = AppConfigUseCase(
        needAppUpdate: {
            return .none
        }
    )
    
    public static func preview(updateType: VersionUpdateType) -> AppConfigUseCase {
        AppConfigUseCase(
            needAppUpdate: {
                return updateType
            }
        )
    }
    
    public static func preview(error: Error) -> AppConfigUseCase {
        AppConfigUseCase(
            needAppUpdate: {
                throw error
            }
        )
    }
}

extension DependencyValues {
    var appConfigUseCase: AppConfigUseCase {
        get { self[AppConfigUseCase.self] }
        set { self[AppConfigUseCase.self] = newValue }
    }
}
