//
//  BasicTime.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//



enum BasicTime: CaseIterable {
    case five
    case fifteen
    case twentyFive
    case oneHour
}

extension BasicTime {
    var title: String {
        switch self {
        case .five: return "5m"
        case .fifteen: return "15m"
        case .twentyFive: return "25m"
        case .oneHour: return "60m"
        }
    }
    
    var seconds: Int {
        switch self {
        case .five: return 5 * 60
        case .fifteen: return 15 * 60
        case .twentyFive: return 25 * 60
        case .oneHour: return 60 * 60
        }
    }
}
