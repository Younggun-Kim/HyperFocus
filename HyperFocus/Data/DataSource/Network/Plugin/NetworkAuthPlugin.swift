//
//  NetworkPlugin.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya
import Alamofire

/// 네트워크 인증 플러그인
public final class NetworkAuthPlugin: PluginType {
    private let tokenProvider: () -> String?
    
    public init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print(request.headers)
        // Authorization 헤더가 이미 있으면 그대로 반환
        guard request.value(forHTTPHeaderField: "Authorization") != nil else {
            return request
        }
        
        // 토큰이 없으면 그대로 반환
        guard let token = tokenProvider() else {
            return request
        }
        
        var request = request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

