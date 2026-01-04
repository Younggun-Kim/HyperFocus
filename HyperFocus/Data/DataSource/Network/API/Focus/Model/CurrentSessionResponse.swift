//
//  CurrentSessionResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct CurrentSessionResponse: Decodable, Sendable, Equatable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case targetDurationSeconds
        case actualDurationSeconds
        case startedAt
        case pausedAt
        case completedAt
        case status
        case ambientSound
        case inputMethod
        case failReason
        case failReasonFeedback
        case satisfaction
        case satisfactionFeedback
        case discardReason
        case minimumDurationMet
        case targetAchieved
    }
}
