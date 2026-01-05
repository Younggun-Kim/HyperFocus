//
//  SatisfactionType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum SatisfactionType: String, Codable  {
    case hyperFocus = "HYPERFOCUS"
    case good = "GOOD"
    case distracted = "DISTRACTED"
    
    init?(rawValue: String) {
        switch rawValue {
        case "HYPERFOCUS": self = .hyperFocus
        case "GOOD": self = .good
        case "DISTRACTED": self = .distracted
        default: return nil
        }
    }
}


extension SatisfactionType {
    var title: String {
        switch self {
        case .hyperFocus: return "완전 몰입"
        case .good: return "좋았어요"
        case .distracted: return "산만했어요"
        }
    }
    
    var icon: String {
        switch self {
        case .hyperFocus: return "🔥"
        case .good: return "😊"
        case .distracted: return "😵‍💫"
        }
    }
}
