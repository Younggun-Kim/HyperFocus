//
//  SettingAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation
import Moya
import Alamofire

public enum SettingAPI {
    case getSetting
    case patchSetting(SettingRequest)
}

extension SettingAPI: BaseTarget {
    public var path: String {
        switch self {
        case .getSetting:
            return "/api/v1/settings"
        case .patchSetting:
            return "/api/v1/settings"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getSetting:
            return .get
        case .patchSetting:
            return .patch
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getSetting:
            return NetworkHeader.authorization
        case .patchSetting:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .getSetting:
            return .requestPlain
        case .patchSetting(let request):
            return .requestJSONEncodable(request)
        }
    }
}
