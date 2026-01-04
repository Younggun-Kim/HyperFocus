//
//  SessionFailReasonType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum SessionFailReasonType: String  {
    case internal = "INTERNAL"
    case external = "EXTERNAL"
    case none = "NONE"
    
    init?(rawValue: String) {
        switch rawValue {
        case "INTERNAL": self = .internal
        case "EXTERNAL": self = .external
        case "NONE": self = .none
        default: return nil
        }
    }
}


extension SessionFailReasonType {
    var title: String {
        switch self {
        case .internal: return "딴생각"
        case .external: return "외부 방해"
        case .none: return "단순 삭제"
        }
    }
    
    var icon: String {
        switch self {
        case .internal: return "🧠"
        case .external: return "📢"
        case .none: return "🗑️"
        }
    }
}
