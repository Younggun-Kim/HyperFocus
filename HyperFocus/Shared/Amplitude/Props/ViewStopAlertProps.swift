//
//  ViewStopAlertProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//
import Foundation


public struct ViewStopAlertProps: Codable {
    let isUnderThreeMinutes: Bool
    let elapsedTime: Int
    
    init(isUnderThreeMinutes: Bool, elapsedTime: Int) {
        self.isUnderThreeMinutes = isUnderThreeMinutes
        self.elapsedTime = elapsedTime
    }

    func toDictionary() -> [String: Any] {
        [
            "alert_type": self.isUnderThreeMinutes ? "under_3m": "over_3m",
            "elapsed_time": self.elapsedTime
        ]
    }
}
