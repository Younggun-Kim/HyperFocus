//
//  ExampleTarget.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//

import Foundation
import Moya
import Alamofire

/// 예시 API Target
/// 실제 API를 추가할 때 이 파일을 참고하세요.
public enum ExampleTarget {
    /// 사용자 정보 조회
    case getUser(id: Int)
    /// 사용자 목록 조회
    case getUsers(page: Int, limit: Int)
    /// 사용자 생성
    case createUser(name: String, email: String)
}

extension ExampleTarget: BaseTarget {
    public var apiVersion: String? {
        return "v1"
    }
    
    public var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        case .getUsers:
            return "/users"
        case .createUser:
            return "/users"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUser, .getUsers:
            return .get
        case .createUser:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        case .getUsers(let page, let limit):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "limit": limit
                ],
                encoding: URLEncoding.queryString
            )
        case .createUser(let name, let email):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "email": email
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}

// MARK: - Response Models

/// 사용자 모델
public struct User: Decodable, Equatable {
    public let id: Int
    public let name: String
    public let email: String
    
    public init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

/// 사용자 목록 응답
public struct UsersResponse: Decodable {
    public let users: [User]
    public let total: Int
    public let page: Int
    public let limit: Int
}

