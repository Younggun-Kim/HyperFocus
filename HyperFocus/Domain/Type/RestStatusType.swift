//
//  RestStatusType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum RestStatusType: String, Codable, Sendable  {
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case skipped = "SKIPPED"
    
    init?(rawValue: String) {
        switch rawValue {
        case "IN_PROGRESS": self = .inProgress
        case "COMPLETED": self = .completed
        case "SKIPPED": self = .skipped
        default: return nil
        }
    }
}
