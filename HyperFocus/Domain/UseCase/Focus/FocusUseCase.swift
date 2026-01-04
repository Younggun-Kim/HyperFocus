//
//  FocusUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation
import ComposableArchitecture

public struct FocusUseCase {
    public let getSuggestions: @Sendable () async throws -> [SuggestionEntity]
    public let startSession: @Sendable (_ params: SessionStartParams) async throws -> SessionEntity?
}

extension FocusUseCase: DependencyKey {
    public static var liveValue = FocusUseCase(
        getSuggestions: {
            @Dependency(\.focusRepository) var focusRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await focusRepository.getSuggestion()
                
                // 서버에 저장된게 없다면 시스템 기본값 반환
                guard let data = response.data else {
                    amplitudeService.track(.viewHome(.init(
                        loadStatus: true,
                        hasHistory: false
                    )))
                    return SuggestionEntity.defaultSuggesions
                }
                
                var suggestions = data.suggestions.map { item in
                    SuggestionEntity(
                        duration: DurationType(seconds: item.durationSeconds),
                        reason: ReasonType(rawValue: item.reason),
                        rank: item.rank
                    )
                }
                
                // 3개 미만이면 defaultSuggesions를 모두 추가하고 3개로 자르기
                if suggestions.count < 3 {
                    let defaultSuggestions = SuggestionEntity.defaultSuggesions
                    suggestions.append(contentsOf: defaultSuggestions)
                    return Array(suggestions.prefix(3))
                }
                
                amplitudeService.track(.viewHome(.init(
                    loadStatus: true,
                    hasHistory: true
                )))
                
                return suggestions
            } catch {
                amplitudeService.track(.viewHome(.init(loadStatus: false, hasHistory: false)))
                return SuggestionEntity.defaultSuggesions
            }
        },
        startSession: {  params in
            @Dependency(\.focusRepository) var focusRepository
            @Dependency(\.amplitudeService) var amplitudeService
            do {
                let response = try await focusRepository.startSession(
                    SessionStartRequest(
                        name: params.name,
                        targetDurationSeconds: params.duration.seconds,
                        inputMethod: params.inputMethod?.rawValue
                    )
                )
                
                if let session = response.data {
                    amplitudeService.track(
                        .startFocusSession(
                            .init(
                                targetDuration: session.targetDurationSeconds,
                                inputMethod: params.inputMethod,
                                setssionTitle: params.name
                            )
                        )
                    )
                }
                
                return response.data?.toEntity()
            } catch let error as APIError {
                // 409 에러인 경우 currentSession을 호출하여 반환
                if case .httpError(let statusCode, _) = error, statusCode == 409 {
                    let currentResponse = try await focusRepository.currentSession()
                    return currentResponse.data?.toEntity()
                }
                throw error
            }
        }
    )
    
    public static var testValue = FocusUseCase(
        getSuggestions: { [] },
        startSession: { _ in  SessionEntity.mock },
    )
    
    public static var previewValue: FocusUseCase {
        testValue
    }
    
    public static func preview(suggestions: [SuggestionEntity]) -> FocusUseCase {
        FocusUseCase(
            getSuggestions: { suggestions },
            startSession: { _ in  SessionEntity.mock },
        )
    }
}

extension DependencyValues {
    var focusUseCase: FocusUseCase {
        get { self[FocusUseCase.self] }
        set { self[FocusUseCase.self] = newValue }
    }
}
