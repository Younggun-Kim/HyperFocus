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
    public let current: @Sendable () async throws -> RestEntity?
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
            } catch let error as APIError {
                // 409 에러인 경우 currentSession을 호출하여 반환
                if case .httpError(let statusCode, _) = error, statusCode == 409 {
                    do {
                        let currentResponse = try await restRepository.current()
                        return currentResponse.data?.toEntity()
                    } catch {
                        throw error
                    }
                }
                
                throw error
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
        current: {
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.current()
                
                return response.data?.toEntity()
            } catch {
                throw error
            }
        },
    )
    
    public static var testValue = RestUseCase(
        start: { _ in RestEntity.mock},
        skip: { _ in RestSkipEntity.mock },
        current: { RestEntity.mock },
    )
    
}

extension DependencyValues {
    var restUseCase: RestUseCase {
        get { self[RestUseCase.self] }
        set { self[RestUseCase.self] = newValue }
    }
}
