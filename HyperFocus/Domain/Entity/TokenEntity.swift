//
//  TokenEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

public struct TokenEntity: Codable, Equatable, Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    
    init(accessToken: String, refreshToken: String, expiresIn: Int, tokenType: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, expiresIn, tokenType
    }
}
