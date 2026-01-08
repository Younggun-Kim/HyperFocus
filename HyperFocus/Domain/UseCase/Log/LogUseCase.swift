//
//  LogUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation
import ComposableArchitecture

public struct LogUseCase {
    public let fetchDashboard: @Sendable () async throws -> DashboardEntity?
}

extension LogUseCase: DependencyKey {
    public static var liveValue = LogUseCase(
        fetchDashboard: {
            @Dependency(\.logRepository) var logRepository
            
            do {
                let response = try await logRepository.fetchDashboard()
                return response.data?.toEntity()
            } catch {
                throw error
            }
        }
    )
    
    public static var testValue = LogUseCase(
        fetchDashboard: { DashboardEntity.mock }
    )
}

extension DependencyValues {
    var logUseCase: LogUseCase {
        get { self[LogUseCase.self] }
        set { self[LogUseCase.self] = newValue }
    }
}

