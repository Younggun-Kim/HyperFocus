//
//  CharWrappingText.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation
import UIKit
import SwiftUI

struct CharWrappingText: UIViewRepresentable {
    let text: String
    let font: UIFont
    let color: UIColor
    let alignment: NSTextAlignment
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping // 글자 단위 줄바꿈
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        label.text = text
        label.contentMode = .topLeft
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = color
        uiView.textAlignment = alignment
        uiView.contentMode = .topLeft
        
    }
}
