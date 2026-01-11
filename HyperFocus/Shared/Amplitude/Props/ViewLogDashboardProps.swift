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
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let todayFocusSeconds = self.todayFocusSeconds {
            dict["today_focus_seconds"] = todayFocusSeconds
        }
        if let diffType = self.diffType {
            dict["diff_type"] = diffType.rawValue
        }
        if let totalSessionCount = self.totalSessionCount {
            dict["total_session_count"] = totalSessionCount
        }
        return dict
    }
}
