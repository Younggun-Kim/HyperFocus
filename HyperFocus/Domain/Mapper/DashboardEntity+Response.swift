//
//  DashboardEntity+Response.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import Foundation

extension DashboardResponse {
    func toEntity() -> DashboardEntity {
        return DashboardEntity(
            isEmpty: self.isEmpty,
            todayFocusSeconds: self.todayFocusSeconds,
            todayFocusDisplay: self.todayFocusDisplay,
            todaySessionCount: self.todaySessionCount,
            diffType: self.diffType.flatMap { DiffType(rawValue: $0) },
            diffSeconds: self.diffSeconds,
            diffMessage: self.diffMessage,
            weekTotalSeconds: self.weekTotalSeconds,
            weekTotalDisplay: self.weekTotalDisplay,
            weeklyData: self.weeklyData.map { $0.toEntity() },
            timeline: self.timeline.compactMap { $0.toEntity() }
        )
    }
}

extension DashboardWeekDataResponse {
    func toEntity() -> WeekDataEntity {
        return WeekDataEntity(
            date: self.date,
            dayOfWeekShort: self.dayOfWeekShort,
            dayOfWeek: self.dayOfWeek,
            focusSeconds: self.focusSeconds,
            focusMinutes: self.focusMinutes,
            sessionCount: self.sessionCount
        )
    }
}

extension DashboardTimelineResponse {
    func toEntity() -> TimelineEntity? {
        guard let type = TimelineType(rawValue: self.type) else {
            return nil
        }
        
        return TimelineEntity(
            type: type,
            sessionId: self.sessionId,
            name: self.name,
            startedAt: self.startedAt,
            endedAt: self.endedAt,
            durationSeconds: self.durationSeconds,
            durationMinutes: self.durationMinutes,
            completionType: self.completionType.flatMap { SessionCompletionType(rawValue: $0) },
            satisfaction: self.satisfaction.flatMap { SatisfactionType(rawValue: $0) },
            targetAchieved: self.targetAchieved,
            isNew: self.isNew
        )
    }
}