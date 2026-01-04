//
//  MileStoneEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation

public struct MileStoneEntity: Codable, Sendable, Equatable {
    var milestoneMinute: Int // 5, 15, 25, 40, 60
    var messageId: String
    var message: String
    var messageKo: String
    var emoji: String
}

extension MileStoneEntity {
    static var mock: Self {
        MileStoneEntity(milestoneMinute: 5, messageId: "1", message: "5분 마쳤습니다.", messageKo: "5분 마쳤습니다.", emoji: "🕒")
    }
}
