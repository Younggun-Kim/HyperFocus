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
    public let currentSession: @Sendable () async throws -> APIResponse<CurrentSessionResponse>
    public let pauseSession: @Sendable (_ sessionId: String) async throws -> APIResponse<SessionResponse>
    public let resumeSession: @Sendable (_ sessionId: String) async throws -> APIResponse<SessionResponse>
    public let abandonSession: @Sendable (_ sessionId: String, _ request: SessionAbandonRequest) async throws -> APIResponse<SessionResponse>
    public let getMileStone: @Sendable (_ sessionId: String, _ minute: Int) async throws -> APIResponse<MileStoneResponse>
    public let completeSession: @Sendable (_ sessionId: String, _ request: SessionCompletionRequest) async throws -> APIResponse<SessionCompletionResponse>
    public let feedbackSession: @Sendable (_ sessionId: String, _ request: SessionFeedbackRequest) async throws -> APIResponse<SessionFeedbackResponse>
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
        },
        currentSession: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.getCurrentSession,
                responseType:CurrentSessionResponse.self
            )
        },
        pauseSession: { sessionId in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.pauseSession(sessionId),
                responseType:SessionResponse.self
            )
        },
        resumeSession: { sessionId in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.resumeSession(sessionId),
                responseType:SessionResponse.self
            )
        },
        abandonSession: { sessionId, request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.abandonSession(sessionId, request),
                responseType:SessionResponse.self
            )
        },
        getMileStone: {sessionId, minute in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.getMileStone(sessionId, minute),
                responseType:MileStoneResponse.self
            )
        },
        completeSession: {sessionId, request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.complete(sessionId, request),
                responseType:SessionCompletionResponse.self
            )
        },
        feedbackSession: {sessionId, request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                FocusAPI.feedback(sessionId, request),
                responseType:SessionFeedbackResponse.self
            )
        },
    )
}

extension DependencyValues {
    public var focusRepository: FocusRepository {
        get { self[FocusRepository.self] }
        set { self[FocusRepository.self] = newValue }
    }
}

