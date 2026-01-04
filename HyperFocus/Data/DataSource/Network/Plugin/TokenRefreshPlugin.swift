//
//  TokenRefreshPlugin.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation
import Moya
import ComposableArchitecture

/// 토큰 갱신 플러그인
/// 401 응답 시 자동으로 토큰을 갱신합니다.
public final class TokenRefreshPlugin: PluginType {
    private let tokenProvider: () -> TokenEntity?
    private let tokenSetter: (TokenEntity) -> Void
    private let refreshProvider: MoyaProvider<MultiTarget>
    
    // 동시성 제어를 위한 액터
    private actor RefreshLock {
        private var isRefreshing = false
        private var refreshContinuation: CheckedContinuation<Void, Never>?
        
        func tryStartRefresh() -> Bool {
            if isRefreshing {
                return false
            }
            isRefreshing = true
            return true
        }
        
        func finishRefresh() {
            isRefreshing = false
            refreshContinuation?.resume()
            refreshContinuation = nil
        }
        
        func waitForRefresh() async {
            if !isRefreshing {
                return
            }
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                refreshContinuation = continuation
            }
        }
    }
    
    private let refreshLock = RefreshLock()
    
    public init(
        tokenProvider: @escaping () -> TokenEntity?,
        tokenSetter: @escaping (TokenEntity) -> Void,
        refreshProvider: MoyaProvider<MultiTarget>
    ) {
        self.tokenProvider = tokenProvider
        self.tokenSetter = tokenSetter
        self.refreshProvider = refreshProvider
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) async {
        print("TokenRefreshPlugin didReceive")
        print("\n\n\(result)\n\n")
        // 성공 응답만 처리
        guard case .success(let response) = result else {
            return
        }
        
        // 401 Unauthorized 응답인지 확인
        guard response.statusCode == 401 else {
            return
        }
        
        // 원본 요청에 Authorization 헤더가 있는지 확인
        guard let originalRequest = response.request,
              originalRequest.value(forHTTPHeaderField: "Authorization") != nil else {
            return
        }
        
        print("😡 Token Refresh")
        // 토큰 갱신 시도
        await self.handleTokenRefresh()
    }
    
    private func handleTokenRefresh() async {
        // 이미 갱신 중이면 대기
        let canStart = await refreshLock.tryStartRefresh()
        if !canStart {
            await refreshLock.waitForRefresh()
            return
        }
        
        guard let token = tokenProvider(),
              !token.refreshToken.isEmpty else {
            print("❌ [TokenRefresh] Refresh token이 없습니다.")
            await refreshLock.finishRefresh()
            return
        }
        
        do {
            // 토큰 갱신 API 직접 호출 (순환 참조 방지)
            let refreshResponse: LoginResponse = try await withCheckedThrowingContinuation { continuation in
                refreshProvider.request(MultiTarget(AuthAPI.refresh(refreshToken: token.refreshToken))) { result in
                    switch result {
                    case .success(let response):
                        guard (200...299).contains(response.statusCode) else {
                            continuation.resume(throwing: NSError(
                                domain: "TokenRefreshPlugin",
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "토큰 갱신 실패: HTTP \(response.statusCode)"]
                            ))
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let decoded = try decoder.decode(LoginResponse.self, from: response.data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: NSError(
                                domain: "TokenRefreshPlugin",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "디코딩 실패: \(error.localizedDescription)"]
                            ))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // 갱신 성공 시 새 토큰 저장
            if refreshResponse.success,
               let loginData = refreshResponse.data {
                let newToken = TokenEntity(
                    accessToken: loginData.accessToken,
                    refreshToken: loginData.refreshToken,
                    expiresIn: loginData.expiresIn,
                    tokenType: loginData.tokenType
                )
                tokenSetter(newToken)
                print("✅ [TokenRefresh] 토큰 갱신 성공")
            } else {
                print("❌ [TokenRefresh] 토큰 갱신 실패: 응답이 성공하지 않음")
            }
        } catch {
            print("❌ [TokenRefresh] 토큰 갱신 실패: \(error.localizedDescription)")
        }
        
        // 갱신 완료
        await refreshLock.finishRefresh()
    }
}
