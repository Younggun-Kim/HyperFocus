//
//  AppVersionAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation
import Moya
import Alamofire

public enum AppVersionAPI {
    /// 앱 버전 체크
    case checkAppVersion(currentVersion: String)
}

extension AppVersionAPI: BaseTarget {
    public var path: String {
        switch self {
        case .checkAppVersion:
            return "/api/v1/app/version/check"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkAppVersion:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .checkAppVersion(let currentVersion):
            return .requestParameters(
                parameters: [
                    "platform": "ios",
                    "currentVersion": currentVersion
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}
