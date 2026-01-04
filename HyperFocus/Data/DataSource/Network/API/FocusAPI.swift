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
    case getSuggestions // 집중 시간 추천 조회
    case startSession(SessionStartRequest) // 집중 세션 시작
    case getCurrentSession
}

extension FocusAPI: BaseTarget {
    public var path: String {
        switch self {
        case .getSuggestions:
            return "/api/v1/focus/suggestions"
        case .startSession:
            return "/api/v1/focus/start"
        case .getCurrentSession:
            return "/api/v1/focus/current"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getSuggestions:
            return .get
        case .startSession:
            return .post
        case .getCurrentSession:
            return .get
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getSuggestions:
            return NetworkHeader.authorization
        case .startSession:
            return NetworkHeader.authorization
        case .getCurrentSession:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .getSuggestions:
            return .requestPlain
        case .startSession(let request):
            return .requestJSONEncodable(request)
        case .getCurrentSession:
            return .requestPlain
            
        }
    }
}
