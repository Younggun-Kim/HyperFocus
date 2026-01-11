//
//  FeedbackRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation

public struct FeedbackRequest: Codable, Equatable, Sendable {
    public let category: String // bug | feature | other
    public let content: String
    public let appVersion: String?
    public let deviceModel: String?
    public let osVersion: String?
}
