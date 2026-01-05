//
//  CompleteFocusSessionProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation


public struct CompleteFocusSessionProps: Codable {
    let isAutoFinish: Bool
    let duration: Int
    
    init(isAutoFinish: Bool, duration: Int) {
        self.isAutoFinish = isAutoFinish
        self.duration = duration
    }
    
    func toDictionary() -> [String: Any] {
        [
            "finish_type": self.isAutoFinish ? "natural": "early_save",
            "actual_duration": self.duration
        ]
    }
}
