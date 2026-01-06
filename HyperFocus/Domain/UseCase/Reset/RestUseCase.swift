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
    public let skip: @Sendable (_ restId: String) async throws -> RestSkipEntity?
    public let current: @Sendable () async throws -> RestEntity?
    public let complete: @Sendable (_ restId: String, _ actualSeconds: Int) async throws -> Bool
    public let extend: @Sendable (_ restId: String) async throws -> RestExtensionEntity?
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
        skip: { restId in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.skip(.init(restId))
                
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
        complete: { restId, seconds in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.complete(restId, .init(actualDurationSeconds: seconds))
                
                return response.data?.status == RestStatusType.completed.rawValue
            } catch {
                throw error
            }
        },
        extend: { restId in
            @Dependency(\.restRepository) var restRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                let response = try await restRepository.extend(restId)
                
                return response.data?.toEntity()
            } catch {
                throw error
            }
            
        }
    )
    
    public static var testValue = RestUseCase(
        start: { _ in RestEntity.mock},
        skip: { _ in RestSkipEntity.mock },
        current: { RestEntity.mock },
        complete: { _, _ in true },
        extend: { _ in RestExtensionEntity.mock },
    )
    
}

extension DependencyValues {
    var restUseCase: RestUseCase {
        get { self[RestUseCase.self] }
        set { self[RestUseCase.self] = newValue }
    }
}
