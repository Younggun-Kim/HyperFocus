//
//  DashboardEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation

public struct DashboardEntity: Sendable {
    var isEmpty: Bool
    var todayFocusSeconds: Int?                        // 오늘 총 집중 시간 (초)
    var todayFocusDisplay: String?                     // 표시용 포맷
    var todaySessionCount: Int?                        // 오늘 세션 수
    var diffType: DiffType?                            // 어제 대비 비교 유형
    var diffSeconds: Int?                              // 어제 대비 차이 (초)
    var diffMessage: String?                           // 비교 메시지
    var weekTotalSeconds: Int?                         // 이번 주 총 집중 시간 (초)
    var weekTotalDisplay: String?                      // 주간 표시용 포맷
    var weeklyData: [WeekDataEntity] = []              // 주간 일별 데이터 (월~일)
    var timeline: [TimelineEntity] = []                // 오늘 타임라인
}

public struct WeekDataEntity: Codable, Sendable {
    var date: String?              // 날짜
    var dayOfWeekShort: String?    // 요일 약자 (M, T, W, T, F, S, S)
    var dayOfWeek: String?         // 요일 Monday
    var focusSeconds: Int?         // 해당일 집중 시간 (초)
    var focusMinutes: Int?         // 해당일 집중 시간 (분)
    var sessionCount: Int?         // 해당일 세션 수
}

extension DashboardEntity {
    static var mock: Self {
        let calendar = Calendar.current
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 주간 데이터 생성 (월~일)
        var weeklyData: [WeekDataEntity] = []
        let dayNames = ["월", "화", "수", "목", "금", "토", "일"]
        let dayNamesShort = ["M", "T", "W", "T", "F", "S", "S"]
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i - 6, to: now) ?? now
            let weekday = calendar.component(.weekday, from: date)
            let adjustedWeekday = (weekday + 5) % 7 // 월요일을 0으로 맞춤
            
            weeklyData.append(WeekDataEntity(
                date: dateFormatter.string(from: date),
                dayOfWeekShort: dayNamesShort[adjustedWeekday],
                dayOfWeek: dayNames[adjustedWeekday],
                focusSeconds: Int.random(in: 3600...14400), // 1시간~4시간
                focusMinutes: Int.random(in: 60...240),
                sessionCount: Int.random(in: 2...8)
            ))
        }
        
        // 타임라인 데이터 생성
        var timeline: [TimelineEntity] = []
        let sessionNames = ["코딩", "독서", "운동", "공부", "작업"]
        
        for i in 0..<5 {
            let startDate = calendar.date(byAdding: .hour, value: -(5-i), to: now) ?? now
            let endDate = calendar.date(byAdding: .minute, value: 30, to: startDate) ?? startDate
            let durationSeconds = Int(endDate.timeIntervalSince(startDate))
            let durationMinutes = durationSeconds / 60
            
            timeline.append(TimelineEntity(
                type: i % 3 == 0 ? .focus : (i % 3 == 1 ? .rest : .gap),
                sessionId: UUID().uuidString,
                name: sessionNames[i % sessionNames.count],
                startedAt: startDate,
                endedAt: endDate,
                durationSeconds: durationSeconds,
                durationMinutes: durationMinutes,
                completionType: i % 2 == 0 ? .auto : .manual,
                satisfaction: [.good, .hyperFocus, .distracted][i % 3],
                targetAchieved: i % 2 == 0,
                isNew: i == 0
            ))
        }
        
        let todayFocusSeconds = 10800 // 3시간
        let weekTotalSeconds = weeklyData.reduce(0) { $0 + ($1.focusSeconds ?? 0) }
        
        return DashboardEntity(
            isEmpty: false,
            todayFocusSeconds: todayFocusSeconds,
            todayFocusDisplay: "3시간",
            todaySessionCount: 5,
            diffType: .increase,
            diffSeconds: 1800,
            diffMessage: "어제보다 30분 더 집중했어요",
            weekTotalSeconds: weekTotalSeconds,
            weekTotalDisplay: "\(weekTotalSeconds / 3600)시간",
            weeklyData: weeklyData,
            timeline: timeline
        )
    }
}
