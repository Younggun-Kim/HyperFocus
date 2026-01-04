//
//  FocusRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation
import ComposableArchitecture

public struct FocusRepository {
    public let getSuggestion: @Sendable () async throws -> APIResponse<FocusSuggestionsResponse>
    public let startSession: @Sendable (_ request: SessionStartRequest) async throws -> APIResponse<SessionStartResponse>
    
}

extension FocusRepository: DependencyKey {
    public static var liveValue = FocusRepository(
        getSuggestion: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.getSuggestions,
                responseType:FocusSuggestionsResponse.self
            )
        },
        startSession: {  request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.startSession(request),
                responseType:SessionStartResponse.self
            )
        }
    )
}

extension DependencyValues {
    public var focusRepository: FocusRepository {
        get { self[FocusRepository.self] }
        set { self[FocusRepository.self] = newValue }
    }
}

