//
//  CommonChip.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import SwiftUI

struct CommonChip: View {
    var title: String
    var style: CommonChipStyle
    var selected: Bool
    var maxLength: Int? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(displayTitle)
                .font(.caption.weight(selected ? .bold : .regular))
                .foregroundStyle(style.foregroundColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                        .fill(selected ? style.selectedBackgroundColor : style.backgroundColor)
                )
        }
    }
    
    private var displayTitle: String {
        guard let maxLength = maxLength, maxLength > 0 else {
            return title
        }
        if title.count > maxLength {
            return String(title.prefix(maxLength)) + "..."
        }
        
        return title
    }
}

#Preview {
    ZStack {
        Color.red.opacity(0.3)
        CommonChip(title: "Reading book", style: .grayFill, selected: true, maxLength: 10, action:{})
    }
}
