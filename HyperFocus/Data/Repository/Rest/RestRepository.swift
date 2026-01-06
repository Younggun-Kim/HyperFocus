//
//  RestRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//


import Foundation
import ComposableArchitecture

public struct RestRepository {
    public let startRest: @Sendable (_ request: RestStartRequest) async throws -> APIResponse<RestResponse>
}

extension RestRepository: DependencyKey {
    public static var liveValue = RestRepository(
        startRest: { request in
            @Dependency(\.apiService) var apiService
            return try await apiService.requestWrapped(
                RestAPI.start(request),
                responseType:RestResponse.self
            )
        },
    )
}

extension DependencyValues {
    public var restRepository: RestRepository {
        get { self[RestRepository.self] }
        set { self[RestRepository.self] = newValue }
    }
}

