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
        }
    )
    
    public static var testValue = FocusUseCase(
        getSuggestions: { [] }
    )
    
    public static var previewValue: FocusUseCase {
        testValue
    }

    public static func preview(suggestions: [SuggestionEntity]) -> FocusUseCase {
        FocusUseCase(
            getSuggestions: {
                return suggestions
            }
        )
    }
}

extension DependencyValues {
    var focusUseCase: FocusUseCase {
        get { self[FocusUseCase.self] }
        set { self[FocusUseCase.self] = newValue }
    }
}
