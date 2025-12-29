//
//  Font+Extensions.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import SwiftUI


extension Font {
    struct CommoingSoon: Hashable {
        static let fontName = "ComingSoon-Regular"
    
        static let largeTitle: Font = .custom(fontName, size: 48)
        static let title: Font = .custom(fontName, size: 25)
    }
}
