//
//  FeedbackResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/12/26.
//

import Foundation

public struct FeedbackResponse: Codable, Equatable, Sendable {
    public let id: String
    public let category: String
    public let textLength: Int
    public let createdAt: Date
}
