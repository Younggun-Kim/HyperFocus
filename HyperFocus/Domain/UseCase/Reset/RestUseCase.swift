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
    public let skip: @Sendable (_ sessionId: String) async throws -> RestSkipEntity?
}

extension RestUseCase: DependencyKey {
    public static var liveValue = RestUseCase(
        start: { sessionId in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.start(
                    .init(focusSessionId: sessionId)
                )
                
                return response.data?.toEntity()
            } catch {
                throw error
            }
        },
        skip: { sessionId in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.skip(.init(sessionId))
                
                return response.data?.toEntity()
            } catch {
                throw error
            }
        },
    )
    
    public static var testValue = RestUseCase(
        start: { _ in RestEntity.mock},
        skip: { _ in RestSkipEntity.mock },
    )
    
}

extension DependencyValues {
    var restUseCase: RestUseCase {
        get { self[RestUseCase.self] }
        set { self[RestUseCase.self] = newValue }
    }
}
