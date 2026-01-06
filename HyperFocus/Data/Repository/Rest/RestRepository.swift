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
    public let skip: @Sendable  (_ restId: String) async throws -> APIResponse<RestSkipResponse>
    public let current: @Sendable () async throws -> APIResponse<RestResponse>
    public let complete: @Sendable (
        _ restId: String, _ request: RestCompletionRequest,
    ) async throws -> APIResponse<RestCompletionResponse>
    public let extend: @Sendable  (_ restId: String) async throws -> APIResponse<RestExtensionResponse>
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
        skip: { restId in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.skip(restId: restId),
                responseType:RestSkipResponse.self
            )
        },
        current: {
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.current,
                responseType:RestResponse.self
            )
        },
        complete: { restId, request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.complete(restId: restId, request: request),
                responseType:RestCompletionResponse.self
            )
        },
        extend: { restId in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.extend(restId: restId),
                responseType:RestExtensionResponse.self
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

