//
//  SessionFailReasonType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum SessionFailReasonType: String, CaseIterable  {
    case internally = "INTERNAL"
    case externally = "EXTERNAL"
    case none = "NONE"
    
    init?(rawValue: String) {
        switch rawValue {
        case "INTERNAL": self = .internally
        case "EXTERNAL": self = .externally
        case "NONE": self = .none
        default: return nil
        }
    }
}


extension SessionFailReasonType {
    var title: String {
        switch self {
        case .internally: return "딴생각"
        case .externally: return "외부 방해"
        case .none: return "단순 삭제"
        }
    }
    
    var reason: String {
        switch self {
        case .internally: return "My mind wandered 🦋"
        case .externally: return "I got interrupted 🔔"
        case .none: return "Just discard it 🗑️"
        }
    }
    
    var icon: String {
        switch self {
        case .internally: return "🧠"
        case .externally: return "📢"
        case .none: return "🗑️"
        }
    }
}
