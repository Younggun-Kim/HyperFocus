//
//  LoginResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//


import Foundation

/// 앱 버전 체크 응답 (BaseResponse의 typealias)
public typealias LoginResponse = BaseResponse<LoginData>

/// 앱 버전 체크 데이터
public struct LoginData: Decodable, Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    public let expiresIn: Int
    
    public init(
        accessToken: String,
        refreshToken: String,
        tokenType: String,
        expiresIn: Int
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
    }
}


extension LoginResponse {
    // Mock 응답 반환
    static let mock = LoginResponse(
        success: true,
        data: LoginData(
            accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
            refreshToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
            tokenType: "Bearer",
            expiresIn: 3600
        ),
        code: "A001"
    )
}

