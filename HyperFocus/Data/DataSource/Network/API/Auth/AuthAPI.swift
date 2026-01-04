//
//  AuthAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import Moya
import Alamofire

public enum AuthAPI {
    /// 앱 버전 체크
    case anonymous(deviceUUID: String)
    /// 토큰 갱신
    case refresh(refreshToken: String)
}

extension AuthAPI: BaseTarget {
    public var path: String {
        switch self {
        case .anonymous:
            return "/api/v1/auth/anonymous"
        case .refresh:
            return "/api/v1/auth/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .anonymous:
            return .post
        case .refresh:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .anonymous(let deviceUUID):
            return .requestParameters(
                parameters: [
                    "deviceId": deviceUUID,
                ],
                encoding: JSONEncoding.default
            )
        case .refresh(let refreshToken):
            return .requestParameters(
                parameters: [
                    "refreshToken": refreshToken,
                ],
                encoding: JSONEncoding.default
            )
            
        }
    }
}
