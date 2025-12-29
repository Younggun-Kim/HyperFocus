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
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
}

#Preview {
    ZStack {
        Color.red.opacity(0.3)
        CommonChip(title: "Reading book", style: .grayFill, selected: true, action:{})
    }
}
