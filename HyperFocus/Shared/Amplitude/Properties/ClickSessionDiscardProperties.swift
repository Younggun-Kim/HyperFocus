//
//  ClickSessionDiscardProperties.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//
import Foundation


public struct ClickSessionDiscardProperties: Codable {
    let isUnderThreeMinutes: Bool
    
    init(isUnderThreeMinutes: Bool) {
        self.isUnderThreeMinutes = isUnderThreeMinutes
    }

    func toDictionary() -> [String: Any] {
        [
            "reason": self.isUnderThreeMinutes ? "warm_up": "give_up",
        ]
    }
}
