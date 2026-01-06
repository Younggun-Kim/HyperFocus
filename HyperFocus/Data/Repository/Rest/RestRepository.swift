//
//  RestRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//


import Foundation
import ComposableArchitecture

public struct RestRepository {
    public let start: @Sendable (_ request: RestStartRequest) async throws -> APIResponse<RestResponse>
    public let skip: @Sendable  (_ sessionId: String) async throws -> APIResponse<RestSkipResponse>
}

extension RestRepository: DependencyKey {
    public static var liveValue = RestRepository(
        start: { request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.start(request),
                responseType:RestResponse.self
            )
        },
        skip: { sessionId in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.skip(sessionId: sessionId),
                responseType:RestSkipResponse.self
            )
        }
    )
}

extension DependencyValues {
    public var restRepository: RestRepository {
        get { self[RestRepository.self] }
        set { self[RestRepository.self] = newValue }
    }
}

