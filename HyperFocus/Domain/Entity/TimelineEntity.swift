//
//  TimelineEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation


public struct TimelineEntity: Sendable {
    var type: TimelineType                        // 타입: 집중 FOCUS, REST, GAP
    var sessionId: String?                        // 세션 ID (UUID)
    var name: String?                             // 세션 이름
    var startedAt: Date                           // 시작 시간
    var endedAt: Date                             // 종료 시간
    var durationSeconds: Int                      // 집중 시간 (초)
    var durationMinutes: Int                      // 집중 시간 (분)
    var completionType: SessionCompletionType?    // AUTO, MANUAL
    var satisfaction: SatisfactionType?           // GOOD, BAD, AVERAGE
    var targetAchieved: Bool?                     // 목표 시간 달성 여부
    var isNew: Bool?                              // 새 세션 여부
}
