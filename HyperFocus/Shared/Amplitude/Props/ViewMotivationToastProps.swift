//
//  ViewMotivationToastProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct ViewMotivationToastProps: Codable {
    let id: String
    let minute: Int
    
    init(id: String, minute: Int) {
        self.id = id
        self.minute = minute
    }

    func toDictionary() -> [String: Any] {
        [
            "milestone_minute": self.minute,
            "message_id": self.id
        ]
    }
}

