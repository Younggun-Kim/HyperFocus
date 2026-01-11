//
//  ClickFeedbackSend.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation


public struct ClickFeedbackSend: Codable {
    let category: String // bug, feature, other
    let textLength: Int
    
    func toDictionary() -> [String: Any] {
        [
            "category": self.category,
            "text_length": self.textLength
        ]
    }
}
