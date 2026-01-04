//
//  SessionStartResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SessionStartResponse: Codable, Sendable, Equatable {
    var id: String
    var name: String
    var targetDurationSeconds: Int
    var actualDurationSeconds: Int
    var startedAt: Date
    var pausedAt: Date?
    var completedAt: Date?
    var status: String // SessionStatusType
    var ambientSound: String?
    var inputMethod: String?
    var failReason: String?
    var failReasonFeedback: String?
    var satisfaction: String?
    var satisfactionFeedback: String?
    var discardReason: String?
    var minimumDurationMet: Bool?
    var targetAchieved: Bool?
}
