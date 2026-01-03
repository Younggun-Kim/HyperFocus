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
}

extension AuthAPI: BaseTarget {
    public var path: String {
        switch self {
        case .anonymous:
            return "/api/v1/auth/anonymous"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .anonymous:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .anonymous(let deviceUUID):
            return .requestParameters(
                parameters: [
                    "deviceId": "deviceUUID",
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}
