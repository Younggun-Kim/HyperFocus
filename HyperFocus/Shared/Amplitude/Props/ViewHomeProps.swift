//
//  ViewHomeProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct ViewHomeProps: Codable {
    let loadStatus: Bool
    let hasHistory: Bool
    
    init(loadStatus: Bool, hasHistory: Bool) {
        self.loadStatus = loadStatus
        self.hasHistory = hasHistory
    }
    
    enum CodingKeys: String, CodingKey {
        case loadStatus = "load_status"
        case hasHistory = "has_history"
    }
    
    func toDictionary() -> [String: Any] {
        [
            "load_status": self.loadStatus ? "success": "error",
            "has_history": self.hasHistory ? "true" : "false"
        ]
    }
}
