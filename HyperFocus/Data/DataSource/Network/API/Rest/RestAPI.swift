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
    case skip(restId: String)
    case current
    case complete(restId: String, request: RestCompletionRequest)
    case extend(restId: String)
}

extension RestAPI: BaseTarget {
    public var path: String {
        switch self {
        case .start:
            return "/api/v1/rest/start"
        case .skip(let restId):
            return "/api/v1/rest/\(restId)/skip"
        case .current:
            return "api/v1/rest/current"
        case .complete(let restId, _):
            return "/api/v1/rest/\(restId)/complete"
        case .extend(let restId):
            return "/api/v1/rest/\(restId)/extend"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .start:
            return .post
        case .skip:
            return .post
        case .current:
            return .get
        case .complete:
            return .post
        case .extend:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .start:
            return NetworkHeader.authorization
        case .skip:
            return NetworkHeader.authorization
        case .current:
            return NetworkHeader.authorization
        case .complete:
            return NetworkHeader.authorization
        case .extend:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .start(let request):
            return .requestJSONEncodable(request)
        case .skip:
            return .requestPlain
        case .current:
            return .requestPlain
        case .complete(_, let request):
            return .requestJSONEncodable(request)
        case .extend:
            return .requestPlain
        }
    }
}
