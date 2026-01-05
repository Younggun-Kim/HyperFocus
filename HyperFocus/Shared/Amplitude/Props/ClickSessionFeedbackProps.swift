//
//  ClickSessionFeedbackProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import Foundation


public struct ClickSessionFeedbackProps: Codable {
    let satisfaction: String
    let sessionId: String
    
    init(satisfaction: String, sessionId: String) {
        self.satisfaction = satisfaction
        self.sessionId = sessionId
    }
    
    func toDictionary() -> [String: Any] {
        [
            "satisfaction": self.satisfaction,
            "sessionId": self.sessionId
        ]
    }
}
