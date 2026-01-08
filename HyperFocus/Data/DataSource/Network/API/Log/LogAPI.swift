//
//  LogAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation
import Moya
import Alamofire

public enum LogAPI {
    case fetchDashboard
}

extension LogAPI: BaseTarget {
    public var path: String {
        switch self {
        case .fetchDashboard:
            return "/api/v1/log/dashboard"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchDashboard: return .get
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .fetchDashboard: return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchDashboard:
            return .requestPlain
        }
    }
}

