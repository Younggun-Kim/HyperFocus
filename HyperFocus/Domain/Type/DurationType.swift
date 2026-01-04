//
//  DurationType.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//


public enum DurationType: CaseIterable, Equatable, Hashable, Sendable {
    case min15
    case min25
    case min45
    case min60
    case custom(Int) // Seconds
    
    public static let allCases: [DurationType] = [.min15, .min25, .min45, .min60]
    
    public init(seconds: Int) {
        switch(seconds) {
        case DurationType.min15.seconds: self = .min15
        case DurationType.min25.seconds: self = .min25
        case DurationType.min45.seconds: self = .min45
        case DurationType.min60.seconds: self = .min60
            
        default: self = .custom(seconds)
        }
    }
}

extension DurationType {
    var title: String {
        switch self {
        case .min15: return "15m"
        case .min25: return "25m"
        case .min45: return "45m"
        case .min60: return "60m"
        case .custom(let value): return "\(value / 60)m"
        }
    }
    
    var seconds: Int {
        switch self {
        case .min15: return 15 * 60
        case .min25: return 25 * 60
        case .min45: return 45 * 60
        case .min60: return 60 * 60
        case .custom(let seconds): return seconds
        }
    }
    
    
}
