//
//  DashboardResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation


public struct DashboardResponse: Codable, Sendable {
    var isEmpty: Bool
    var todayFocusSeconds: Int?                        // 오늘 총 집중 시간 (초)
    var todayFocusDisplay: String?                     // 표시용 포맷
    var todaySessionCount: Int?                        // 오늘 세션 수
    var diffType: String?                              // 어제 대비 비교 유형
    var diffSeconds: Int?                              // 어제 대비 차이 (초)
    var diffMessage: String?                           // 비교 메시지
    var weekTotalSeconds: Int?                         // 이번 주 총 집중 시간 (초)
    var weekTotalDisplay: String?                      // 주간 표시용 포맷
    var weeklyData: [DashboardWeekDataResponse] = []   // 주간 일별 데이터 (월~일)
    var timeline: [DashboardTimelineResponse] = []     // 오늘 타임라인
}

public struct DashboardWeekDataResponse: Codable, Sendable {
    var date: String?              // 날짜
    var dayOfWeekShort: String?    // 요일 약자 (M, T, W, T, F, S, S)
    var dayOfWeek: String?         // 요일 Monday
    var focusSeconds: Int?         // 해당일 집중 시간 (초)
    var focusMinutes: Int?         // 해당일 집중 시간 (분)
    var sessionCount: Int?         // 해당일 세션 수
}

public struct DashboardTimelineResponse: Codable, Sendable {
    var type: String               // 타입: 집중 FOCUS, REST, GAP
    var sessionId: String?         // 세션 ID (UUID)
    var name: String?              // 세션 이름
    var startedAt: Date            // 시작 시간
    var endedAt: Date              // 종료 시간
    var durationSeconds: Int       // 집중 시간 (초)
    var durationMinutes: Int       // 집중 시간 (분)
    var completionType: String?    // AUTO, MANUAL
    var satisfaction: String?      // GOOD, BAD, AVERAGE
    var targetAchieved: Bool?      // 목표 시간 달성 여부
    var isNew: Bool?               // 새 세션 여부
}
