//
//  SessionCompletionEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SessionCompletionEntity: Sendable, Equatable {
    var id: String // UUID
    var status: SessionStatusType // SessionStatusType
    var actualDurationSeconds: Int // 1500
    var completionType: SessinCompletionType // AUTO(00:00 도달) | MANUAL(Save 클릭)
    var completedAt: Date // 2025-12-26T10:25:00
    var minimumDurationMet: Bool // 3분 이상 집중 여부
    var targetAchieved: Bool  // 목표 시간 달성 여부
}


extension SessionCompletionEntity {
    static var mock: SessionCompletionEntity {
        .init(
            id: UUID().uuidString,
            status: .completed,
            actualDurationSeconds: 1500,
            completionType: .auto,
            completedAt: Date(),
            minimumDurationMet: true,
            targetAchieved: true,            
        )
    }
}
