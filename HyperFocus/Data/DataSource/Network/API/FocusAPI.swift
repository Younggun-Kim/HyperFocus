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
    case getCurrentSession // 현재 세션 조회
    case pauseSession(String) // 세션 일시 정지
    case resumeSession(String) // 세션 재시작
    case abandonSession(String, SessionAbandonRequest) // 세션 포기
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
        case .pauseSession(let sessionId):
            return "/api/v1/focus/\(sessionId)/pause"
        case .resumeSession(let sessionId):
            return "/api/v1/focus/\(sessionId)/resume"
        case .abandonSession(let sessionId, _):
            return "/api/v1/focus/\(sessionId)/abandon"
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
        case .pauseSession:
            return .post
        case .resumeSession:
            return .post
        case .abandonSession:
            return .post
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
        case .pauseSession:
            return NetworkHeader.authorization
        case .resumeSession:
            return NetworkHeader.authorization
        case .abandonSession:
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
        case .pauseSession:
            return .requestPlain
        case .resumeSession:
            return .requestPlain
        case .abandonSession(_, let request):
            return .requestJSONEncodable(request)
        }
    }
}
