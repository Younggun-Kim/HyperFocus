//
//  TimelineType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

public enum TimelineType: Sendable {
    case focus
    case rest
    case gap
    
    public init?(rawValue: String) {
        switch(rawValue) {
        case "FOCUS": self = .focus
        case "REST": self = .rest
        case "GAP": self = .gap
        default: return nil
        }
    }
}
