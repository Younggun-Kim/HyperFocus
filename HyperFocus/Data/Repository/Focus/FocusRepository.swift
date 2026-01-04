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
}

extension FocusRepository: DependencyKey {
    public static var liveValue = FocusRepository(
        getSuggestion: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.getSuggestions,
                responseType:FocusSuggestionsResponse.self
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

