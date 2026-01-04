//
//  SessionStatusType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum SessionStatusType: String  {
    case inProgress = "IN_PROGRESS"
    case paused = "PAUSED"
    case completed = "COMPLETED"
    case abandoned = "ABANDONED"
    
    init?(rawValue: String) {
        switch rawValue {
        case "IN_PROGRESS": self = .inProgress
        case "PAUSED": self = .paused
        case "COMPLETED": self = .completed
        case "ABANDONED": self = .abandoned
        default: return nil
        }
    }
}
extension SessionStatusType {
    var isPlaying: Bool {
        switch self {
        case .inProgress, .paused: return true
        case .completed, .abandoned: return false
        }
    }
}
