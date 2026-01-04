//
//  FocusAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//


import Foundation
import Moya
import Alamofire

public enum FocusAPI {
    /// 집중 시간 추천 조회
    case getSuggestions
}

extension FocusAPI: BaseTarget {
    public var path: String {
        switch self {
        case .getSuggestions:
            return "/api/v1/focus/suggestions"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getSuggestions:
            return .get
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getSuggestions:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .getSuggestions:
            return .requestPlain
        }
    }
}
