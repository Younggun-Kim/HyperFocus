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
}

extension RestAPI: BaseTarget {
    public var path: String {
        switch self {
        case .start:
            return "/api/v1/rest/start"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .start:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .start:
            return NetworkHeader.authorization
        }
    }
    
    public var task: Task {
        switch self {
        case .start(let request):
            return .requestJSONEncodable(request)
        }
    }
}
