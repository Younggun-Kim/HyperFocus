//
//  RestAPI.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//



import Foundation
import Moya
import Alamofire

public enum RestAPI {
    case start(RestStartRequest)
    case skip(sessionId: String)
}

extension RestAPI: BaseTarget {
    public var path: String {
        switch self {
        case .start:
            return "/api/v1/rest/start"
        case .skip(let sessionId):
            return "/api/v1/rest/{sessionId}/skip"
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .start:
            return .post
        case .skip:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .start:
            return NetworkHeader.authorization
        case .skip:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .start(let request):
            return .requestJSONEncodable(request)
        case .skip:
            return .requestPlain
        }
    }
}
