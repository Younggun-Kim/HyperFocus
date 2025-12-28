//
//  AmbientStyle.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import SwiftUI


enum AmbientStyleType: String, Codable {
    case allBlack
    
    case all282828
    
    case black
    
    case blueDark
}

struct AmbientStyle {
    var baseColor: Color
    var topLeftColor: Color
    var topRightColor: Color
    var bottomRightColor: Color
    
    init(styleType: AmbientStyleType) {
        switch styleType {
        case .allBlack:
            self.baseColor = .black
            self.topLeftColor = .black
            self.topRightColor = .black
            self.bottomRightColor = .black
        case .all282828:
            self.baseColor = .init(hex: "#282828")
            self.topLeftColor = .init(hex: "#282828")
            self.topRightColor = .init(hex: "#282828")
            self.bottomRightColor = .init(hex: "#282828")
        case .black:
            self.baseColor = .black.opacity(0.7)
            self.topLeftColor = .init(hex: "#203A43")
            self.topRightColor = .init(hex: "#0F2027")
            self.bottomRightColor = .init(hex: "#2C5364")
        case .blueDark:
            self.baseColor = .white
            self.topLeftColor = .init(hex: "#B8E4FF")
            self.topRightColor = .init(hex: "#43FFC4")
            self.bottomRightColor = .init(hex: "#AF78C9")
        }
    }
}

extension AmbientStyleType {
    var ambientStyle: AmbientStyle {
        return AmbientStyle(styleType: self)
    }
    
    var baseColor: Color {
        return self.ambientStyle.baseColor
    }
    
    var topLeftColor: Color {
        return self.ambientStyle.topLeftColor
    }
    
    var topRightColor: Color {
        return self.ambientStyle.topRightColor
    }
    
    var bottomRightColor: Color {
        return self.ambientStyle.bottomRightColor
    }
}
