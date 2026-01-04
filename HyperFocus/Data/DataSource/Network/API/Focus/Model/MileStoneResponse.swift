//
//  MileStoneResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct MileStoneResponse: Codable, Sendable, Equatable {
    var milestoneMinute: Int // 5, 15, 25, 40, 60
    var messageId: String
    var message: String
    var messageKo: String
    var emoji: String
}

extension MileStoneResponse {
    static var mock: Self {
        MileStoneResponse(milestoneMinute: 5, messageId: "15m_flow", message: "5분 마쳤습니다.", messageKo: "5분 마쳤습니다.", emoji: "🕒")
    }
}
