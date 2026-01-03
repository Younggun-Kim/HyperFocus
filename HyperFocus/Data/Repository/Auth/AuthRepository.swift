//
//  AuthRepository.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import ComposableArchitecture

public struct AuthRepository {
    public let getToken: @Sendable () -> TokenEntity?
    public let setToken: @Sendable (_ token: TokenEntity) -> Void
    public let deleteToken: @Sendable () -> Void
    public let anonymousLogin: @Sendable (_ deviceUUID: String) async throws -> LoginResponse
}

extension AuthRepository: DependencyKey {
    public static var liveValue: AuthRepository = AuthRepository(
        getToken: {
            @Dependency(\.localDataSource) var localDataSource
            return localDataSource.getToken()
        },
        setToken: { token in
            @Dependency(\.localDataSource) var localDataSource
            localDataSource.setToken(token)
        },
        deleteToken: {
            @Dependency(\.localDataSource) var localDataSource
            localDataSource.deleteToken()
        },
        anonymousLogin: { deviceUUID in
            @Dependency(\.apiService) var apiService
            return try await apiService.request(
                AuthAPI.anonymous(deviceUUID: deviceUUID),
                responseType: LoginResponse.self
            )
        }
    )
    
    public static var testValue: AuthRepository = AuthRepository(
        getToken: { nil },
        setToken: { _ in },
        deleteToken: {},
        anonymousLogin: { _ in .mock }
    )
    
    public static var previewValue: AuthRepository {
        testValue
    }
}

extension DependencyValues {
    public var authRepository: AuthRepository {
        get { self[AuthRepository.self] }
        set { self[AuthRepository.self] = newValue }
    }
}
