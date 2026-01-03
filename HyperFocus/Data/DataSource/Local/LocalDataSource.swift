//
//  LocalDataSource.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import ComposableArchitecture

public struct LocalDataSource {
    public let getToken: @Sendable () -> TokenEntity?
    public let setToken: @Sendable (_ token: TokenEntity) -> Void
    public let deleteToken: @Sendable () -> Void
}

extension LocalDataSource: DependencyKey {
    private static let tokenKey = "token"
    
    public static var liveValue = LocalDataSource(
        getToken: {
            @Dependency(\.userDefaults) var userDefaults
            
            guard let data = userDefaults.data(forKey: tokenKey) else {
                return nil
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TokenEntity.self, from: data)
            } catch {
                return nil
            }
        },
        setToken: { token in
            @Dependency(\.userDefaults) var userDefaults
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(token)
                userDefaults.set(data, forKey: tokenKey)
            } catch {
                // 인코딩 실패 시 무시 (또는 에러 로깅)
            }
        },
        deleteToken: {
            @Dependency(\.userDefaults) var userDefaults
            userDefaults.removeObject(forKey: tokenKey)
        }
    )
    
    public static var testValue = LocalDataSource(
        getToken: { nil },
        setToken: { _ in },
        deleteToken: {}
    )
}

extension DependencyValues {
    public var localDataSource: LocalDataSource {
        get { self[LocalDataSource.self] }
        set { self[LocalDataSource.self] = newValue }
    }
}
