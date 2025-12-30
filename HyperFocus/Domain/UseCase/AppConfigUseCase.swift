//
//  AppConfigUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import ComposableArchitecture

public struct AppConfigUseCase {
    public let needAppUpdate: @Sendable () async throws -> Bool
}

extension AppConfigUseCase: DependencyKey {
    public static var liveValue = AppConfigUseCase(
        needAppUpdate: {
            @Dependency(\.userDefaults) var userDefaults
            
            return false
        }
    )
    
    // Preview용 기본값
    public static var previewValue = AppConfigUseCase(
        needAppUpdate: {
            return false
        }
    )
    
    public static func preview(needUpdate: Bool) -> AppConfigUseCase {
        AppConfigUseCase(
            needAppUpdate: {
                return needUpdate
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
