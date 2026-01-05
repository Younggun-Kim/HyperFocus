//
//  SessionCompletionType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


enum SessionCompletionType: String  {
    case auto = "AUTO"
    case manual = "MANUAL"
    case abandoned = "ABANDONED"
    
    init?(rawValue: String) {
        switch rawValue {
        case "AUTO": self = .auto
        case "MANUAL": self = .manual
        case "ABANDONED": self = .abandoned
        default: return nil
        }
    }
}
