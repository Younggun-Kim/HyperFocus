//
//  RestUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//


import Foundation
import ComposableArchitecture

public struct RestUseCase {
    public let start: @Sendable (_ sessionId: String) async throws -> RestEntity?
}

extension RestUseCase: DependencyKey {
    public static var liveValue = RestUseCase(
        start: { sessionId in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.startRest(
                    .init(focusSessionId: sessionId)
                )
                
                return response.data?.toEntity()
            } catch {
                throw error
            }
        },
    )
    
    public static var testValue = RestUseCase(
        start: { _ in RestEntity.mock}
    )
    
}

extension DependencyValues {
    var restUseCase: RestUseCase {
        get { self[RestUseCase.self] }
        set { self[RestUseCase.self] = newValue }
    }
}
