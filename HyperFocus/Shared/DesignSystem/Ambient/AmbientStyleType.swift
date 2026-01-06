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
    case calmDark
}

struct AmbientGradientPoint {
    var color: Color
    var position: CGSize
    var blur: CGFloat
    
    init(color: Color, position: CGSize, blur: CGFloat = 400) {
        self.color = color
        self.position = position
        self.blur = blur
    }
}

struct AmbientStyle {
    var baseColor: Color
    var topLeft: AmbientGradientPoint
    var topRight: AmbientGradientPoint
    var bottomRight: AmbientGradientPoint
    
    init(styleType: AmbientStyleType) {
        switch styleType {
        case .allBlack:
            self.baseColor = .black
            self.topLeft = AmbientGradientPoint(color: .black, position: .init(width: 0.1, height: 0.1))
            self.topRight = AmbientGradientPoint(color: .black, position: .init(width: 0.9, height: 0.1))
            self.bottomRight = AmbientGradientPoint(color: .black, position: .init(width: 0.9, height: 0.55))
            
        case .all282828:
            self.baseColor = .init(hex: "#282828")
            self.topLeft = AmbientGradientPoint(color: .init(hex: "#282828"), position: .init(width: 0.1, height: 0.1))
            self.topRight = AmbientGradientPoint(color: .init(hex: "#282828"), position: .init(width: 0.9, height: 0.1))
            self.bottomRight = AmbientGradientPoint(color: .init(hex: "#282828"), position: .init(width: 0.9, height: 0.55))
            
        case .black:
            self.baseColor = .black.opacity(0.7)
            self.topLeft = AmbientGradientPoint(color: .init(hex: "#203A43"), position: .init(width: 0.1, height: 0.1))
            self.topRight = AmbientGradientPoint(color: .init(hex: "#0F2027"), position: .init(width: 0.9, height: 0.1))
            self.bottomRight = AmbientGradientPoint(color: .init(hex: "#2C5364"), position: .init(width: 0.9, height: 0.55))
            
        case .blueDark:
            self.baseColor = .white
            self.topLeft = AmbientGradientPoint(color: .init(hex: "#B8E4FF"), position: .init(width: 0.1, height: 0.1))
            self.topRight = AmbientGradientPoint(color: .init(hex: "#43FFC4"), position: .init(width: 0.9, height: 0.1))
            self.bottomRight = AmbientGradientPoint(color: .init(hex: "#AF78C9"), position: .init(width: 0.9, height: 0.55))
            
        case .calmDark:
            self.baseColor = .black
            self.topLeft = AmbientGradientPoint(
                color: .init(hex: "#6D9CB9"),
                position: .init(width: 0.1, height: 0.1),
                blur: 150
            )
            self.topRight = AmbientGradientPoint(
                color: .init(hex: "#0E7252"),
                position: .init(width: 0.9, height: 0.1),
                blur: 150
            )
            self.bottomRight = AmbientGradientPoint(
                color: .init(hex: "#343573"),
                position: .init(width: 0.85, height: 1),
                blur: 150
            )
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
        return self.ambientStyle.topLeft.color
    }

    var topLeftPosition: CGSize {
        return self.ambientStyle.topLeft.position
    }

    var topLeftBlur: CGFloat {
        return self.ambientStyle.topLeft.blur
    }
    
    var topRightColor: Color {
        return self.ambientStyle.topRight.color
    }

    var topRightPosition: CGSize {
        return self.ambientStyle.topRight.position
    }

    var topRightBlur: CGFloat {
        return self.ambientStyle.topRight.blur
    }
    
    var bottomRightColor: Color {
        return self.ambientStyle.bottomRight.color
    }
    
    var bottomRightPosition: CGSize {
        return self.ambientStyle.bottomRight.position
    }

    var bottomRightBlur: CGFloat {
        return self.ambientStyle.bottomRight.blur
    }
}
