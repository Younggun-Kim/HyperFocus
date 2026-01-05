//
//  SessionCompletionResponse.swift.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation

public struct SessionCompletionResponse: Codable {
    var id: String // UUID
    var status: String // SessionStatusType
    var actualDurationSeconds: Int // 1500
    var completionType: String // AUTO(00:00 도달) | MANUAL(Save 클릭)
    var completedAt: Date // 2025-12-26T10:25:00
    var minimumDurationMet: Bool // 3분 이상 집중 여부
    var targetAchieved: Bool  // 목표 시간 달성 여부
}
