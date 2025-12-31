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
                NetworkLoggingPlugin(verbose: true)
                // NetworkAuthPlugin { AuthManager.shared.token } // 필요시 활성화
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
        APIService()
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

