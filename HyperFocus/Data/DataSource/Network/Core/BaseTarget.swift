//
//  BaseTarget.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya

/// 기본 TargetType 프로토콜
/// 모든 API Target은 이 프로토콜을 준수해야 합니다.
public protocol BaseTarget: TargetType {
}

public extension BaseTarget {
    /// 기본 baseURL (환경에 따라 변경 가능)
    var baseURL: URL {
        return Environment.apiBaseURL
    }
    
    /// 기본 헤더
    var headers: [String: String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        // TODO: 인증 토큰 추가
        // if let token = AuthManager.shared.token {
        //     headers["Authorization"] = "Bearer \(token)"
        // }
        
        return headers
    }
    
    /// 기본 샘플 데이터 (테스트용)
    var sampleData: Data {
        return Data()
    }
    
    /// 기본 validation 타입
    var validationType: ValidationType {
        return .successCodes
    }
}

