//
//  BaseResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

import Foundation

public struct BaseResponse<T: Decodable & Equatable & Sendable>: Decodable, Equatable, Sendable {
    public let success: Bool
    public let data: T?
    public let code: String?
    public let message: String?
    
    public init(
        success: Bool,
        data: T? = nil,
        code: String? = nil,
        message: String? = nil
    ) {
        self.success = success
        self.data = data
        self.code = code
        self.message = message
    }
}

