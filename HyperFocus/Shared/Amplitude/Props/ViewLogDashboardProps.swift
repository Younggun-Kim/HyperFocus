//
//  ViewLogDashboardProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//
import Foundation


public struct ViewLogDashboardProps: Codable {
    let todayFocusSeconds: Int?
    let diffType: DiffType?
    let totalSessionCount: Int?
    
    init(
        todayFocusSeconds: Int?,
        diffType: DiffType?,
        totalSessionCount: Int?
    ) {
        self.todayFocusSeconds = todayFocusSeconds
        self.diffType = diffType
        self.totalSessionCount = totalSessionCount
    }
    
    func toDictionary() -> [String: Any?] {
        [
            "today_focus_seconds": self.todayFocusSeconds,
            "diff_type": self.diffType?.rawValue,
            "total_session_count": self.totalSessionCount
        ]
    }
}
