//
//  AmbientStyle.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import SwiftUI


enum AmbientStyle: String, Codable {
    case allBlack
    
    case all282828
    
    case black
    
    case blueDark
}

extension AmbientStyle {
    var baseColor: Color {
        switch self {
        case .allBlack:
            return .black
        case .all282828:
            return .init(hex:"#282828")
        case .black:
            return .black.opacity(0.7)
        case .blueDark:
            return .white
        }
    }
    var topLeftColor: Color {
        switch self {
        case .allBlack:
            return .black
        case .all282828:
            return .init(hex:"#282828")
        case .black:
            return .init(hex:"#203A43")
        case .blueDark:
            return .init(hex:"#B8E4FF")
        }
    }
    
    var topRightColor: Color {
        switch self {
        case .allBlack:
            return .black
        case .all282828:
            return .init(hex:"#282828")
        case .black:
            return .init(hex:"#0F2027")
        case .blueDark:
            return .init(hex:"#43FFC4")
        }
    }
    
    var bottomRightColor: Color {
        switch self {
        case .allBlack:
            return .black
        case .all282828:
            return .init(hex:"#282828")
        case .black:
            return .init(hex:"#2C5364")
        case .blueDark:
            return .init(hex:"#AF78C9")
        }
    }
}
