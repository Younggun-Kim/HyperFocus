//
//  LoginUseCase.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import ComposableArchitecture

struct LoginUseCase {
    public let autoLogin: @Sendable () async throws -> Bool
    
}

extension LoginUseCase: DependencyKey {
    static var liveValue = LoginUseCase(
        autoLogin: {
            @Dependency(\.appRepository) var appRepository
            @Dependency(\.authRepository) var authRepository
            @Dependency(\.amplitudeService) var amplitudeService
            
            do {
                // 저장된 토큰이 있다면 로그인 처리
                // 토큰 갱신은 Api Interceptor에서 처리
                if let storedToken = authRepository.getToken() {
                    let loginResponse = try await authRepository.refreshToken(storedToken.refreshToken)
                    
                    if loginResponse.success,
                       let newToken = loginResponse.data?.toTokenEntity(){
                        authRepository.setToken(newToken)
                        
                        return true
                    }
                }
                
                // 저장된 토큰이 없다면 익명 로그인 작업
                if  let deviceUUID = try await appRepository.getDeviceUUID() {
                    // Amplitude 디바이스ID 저장
                    amplitudeService.setDeviceId(deviceUUID)
                    
                    let loginResponse = try await authRepository.anonymousLogin(deviceUUID)
                    
                    if loginResponse.success,
                       let newToken = loginResponse.data?.toTokenEntity(){
                        authRepository.setToken(newToken)
                    }
                    
                    // TODO: - Push 토큰 저장 추가
                    
                    return loginResponse.success
                }
                
                return false
            } catch {
                throw error
            }
        }
    )
    
    static var testValue = LoginUseCase(
        autoLogin: { false }
    )
    
    static var previewValue: LoginUseCase {
        testValue
    }
}

extension DependencyValues {
    var loginUseCase: LoginUseCase {
        get { self[LoginUseCase.self] }
        set { self[LoginUseCase.self] = newValue }
    }
}

extension LoginData {
    func toTokenEntity() -> TokenEntity {
        TokenEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: expiresIn,
            tokenType: tokenType
        )
    }
}
