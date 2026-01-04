//
//  APIService.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya
import ComposableArchitecture

/// 네트워크 API 서비스 프로토콜
public protocol APIServiceProtocol {
    /// 요청 실행
    func request<T: BaseTarget, D: Decodable>(
        _ target: T,
        responseType: D.Type
    ) async throws -> D
    
    /// 요청 실행 (APIResponse 래핑)
    func requestWrapped<T: BaseTarget, D: Decodable>(
        _ target: T,
        responseType: D.Type
    ) async throws -> APIResponse<D>
}

/// 네트워크 API 서비스 구현
public struct APIService: APIServiceProtocol {
    private let provider: MoyaProvider<MultiTarget>
    
    public init(provider: MoyaProvider<MultiTarget>? = nil) {
        if let provider = provider {
            self.provider = provider
        } else {
            // 기본 플러그인 설정
            let plugins: [PluginType] = [
                NetworkLoggingPlugin(verbose: true),
            ]
            
            self.provider = MoyaProvider<MultiTarget>(
                plugins: plugins
            )
        }
    }
    
    /// 기본 요청 실행
    public func request<T: BaseTarget, D: Decodable>(
        _ target: T,
        responseType: D.Type
    ) async throws -> D {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    // HTTP 상태 코드 검증
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: APIError.httpError(
                            statusCode: response.statusCode,
                            message: String(data: response.data, encoding: .utf8)
                        ))
                        return
                    }
                    
                    // JSON 디코딩
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decoded = try decoder.decode(D.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decodingError("디코딩 실패: \(error.localizedDescription)"))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: APIError.from(error))
                }
            }
        }
    }
    
    /// APIResponse로 래핑된 요청 실행
    public func requestWrapped<T: BaseTarget, D: Decodable>(
        _ target: T,
        responseType: D.Type
    ) async throws -> APIResponse<D> {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    // HTTP 상태 코드 검증
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: APIError.httpError(
                            statusCode: response.statusCode,
                            message: String(data: response.data, encoding: .utf8)
                        ))
                        return
                    }
                    
                    // JSON 디코딩
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        // ISO8601 Date 포맷 설정 (마이크로초 포함 지원)
                        if #available(iOS 10.0, *) {
                            let iso8601Formatter = ISO8601DateFormatter()
                            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            decoder.dateDecodingStrategy = .custom { decoder in
                                let container = try decoder.singleValueContainer()
                                let dateString = try container.decode(String.self)
                                
                                // ISO8601DateFormatter로 먼저 시도
                                if let date = iso8601Formatter.date(from: dateString) {
                                    return date
                                }
                                
                                // 실패 시 커스텀 포맷 시도 (마이크로초 포함)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                
                                if let date = dateFormatter.date(from: dateString) {
                                    return date
                                }
                                
                                // 밀리초만 있는 경우
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                if let date = dateFormatter.date(from: dateString) {
                                    return date
                                }
                                
                                // 초만 있는 경우
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                if let date = dateFormatter.date(from: dateString) {
                                    return date
                                }
                                
                                throw DecodingError.dataCorruptedError(
                                    in: container,
                                    debugDescription: "날짜 형식이 올바르지 않습니다: \(dateString)"
                                )
                            }
                        } else {
                            // iOS 10 미만에서는 기본 ISO8601 사용
                            decoder.dateDecodingStrategy = .iso8601
                        }
                        
                        let decoded = try decoder.decode(APIResponse<D>.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: APIError.decodingError("디코딩 실패: \(error.localizedDescription)"))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: APIError.from(error))
                }
            }
        }
    }
}

// MARK: - TCA Dependency

extension APIService: DependencyKey {
    public static var liveValue: APIService {
        @Dependency(\.localDataSource) var localDataSource
        
        // 매 요청마다 최신 토큰을 가져오는 클로저
        let tokenProvider: () -> String? = {
            return localDataSource.getToken()?.accessToken
        }
        
        // 토큰 갱신 전용 Provider (플러그인 없이, 순환 참조 방지)
        let refreshProvider = MoyaProvider<MultiTarget>(
            plugins: [NetworkLoggingPlugin(verbose: false)] // 로깅만, 인증 플러그인 없음
        )
        
        // 토큰 갱신 플러그인 설정
        let tokenRefreshPlugin = TokenRefreshPlugin(
            tokenProvider: {
                localDataSource.getToken()
            },
            tokenSetter: { token in
                localDataSource.setToken(token)
            },
            refreshProvider: refreshProvider
        )
        
        let plugins: [PluginType] = [
            NetworkAuthPlugin(tokenProvider: tokenProvider),
            tokenRefreshPlugin,
            NetworkLoggingPlugin(verbose: true),
        ]
        
        let provider = MoyaProvider<MultiTarget>(plugins: plugins)

        return APIService(provider: provider)
    }
    
    public static var testValue: APIService {
        // 테스트용 Mock Provider
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        
        let provider = MoyaProvider<MultiTarget>(
            endpointClosure: endpointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )
        
        return APIService(provider: provider)
    }
    
    public static var previewValue: APIService {
        testValue
    }
}

extension DependencyValues {
    public var apiService: APIService {
        get { self[APIService.self] }
        set { self[APIService.self] = newValue }
    }
}

