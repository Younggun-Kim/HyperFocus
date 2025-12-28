//
//  CommonChipStyle.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import SwiftUI


enum CommonChipStyle {
    case gray
    case grayFill
}

extension CommonChipStyle {
    
    private var model : CommonChipStyleModel {
        return CommonChipStyleModel(CommonChipStyle: self)
    }
    
    var foregroundColor: Color {
        return model.foregroundColor
    }
    
    var backgroundColor: Color {
        return model.backgroundColor
    }
    
    var selectedBackgroundColor: Color {
        return model.selectedBackgroundColor
    }
    
    var borderColor: Color {
        return model.borderColor
    }
    
    var borderWidth: CGFloat {
        return model.borderWidth
    }
}

struct CommonChipStyleModel {
    var foregroundColor: Color
    var backgroundColor: Color
    var selectedBackgroundColor: Color
    var borderColor: Color
    var borderWidth: CGFloat
    
    init(CommonChipStyle: CommonChipStyle) {
        switch CommonChipStyle {
        case .gray:
            self.foregroundColor = Color.systemGray
            self.backgroundColor = Color.clear
            self.selectedBackgroundColor = Color.clear
            self.borderColor = Color.systemLightGray.opacity(0.3)
            self.borderWidth = 1
        case .grayFill:
            self.foregroundColor = Color.white
            self.backgroundColor = Color.systemGray
            self.selectedBackgroundColor = Color.systemBlue
            self.borderColor = Color.clear
            self.borderWidth = 0
        }
    }
}
