//
//  LogRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation
import ComposableArchitecture

public struct LogRepository {
    public let fetchDashboard: @Sendable () async throws -> APIResponse<DashboardResponse>
}

extension LogRepository: DependencyKey {
    public static var liveValue = LogRepository(
        fetchDashboard: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                LogAPI.fetchDashboard,
                responseType:DashboardResponse.self
            )
        },
    )
}

extension DependencyValues {
    public var logRepository: LogRepository {
        get { self[LogRepository.self] }
        set { self[LogRepository.self] = newValue }
    }
}

