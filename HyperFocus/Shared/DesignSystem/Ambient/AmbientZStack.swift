//
//  BackgroundColors.swift
//  HyperFocus
//
//  Created by 김영건 on 12/21/25.
//

import SwiftUI


struct AmbientZStack<Content: View>: View {
    var style: AmbientStyleType
    var alignment: Alignment = .center
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: alignment) {
                // 1. Base Background (맨 밑바닥)
                style.baseColor
                    .ignoresSafeArea()
                
                // 2. Circle 1: 좌측 상단 (Top-Left)
                Circle()
                    .fill(style.topLeftColor)
                    .frame(width: 600, height: 600)
                    .blur(radius: style.topLeftBlur)
                    .position(
                        x: 0, 
                        y: 0,
                    )
                
                // 3. Circle 2: 우측 상단 (Top-Right)
                Circle()
                    .fill(style.topRightColor)
                    .frame(width: 600, height: 600)
                    .blur(radius: style.topRightBlur)
                    .position(
                        x: geometry.size.width * style.topRightPosition.width, 
                        y: 0
                    )
                
                // 4. Circle 3: 우측 하단 (Bottom-Right)
                Circle()
                    .fill(style.bottomRightColor)
                    .frame(width: 637, height: 637)
                    .blur(radius: style.bottomRightBlur)
                    .position(
                        x: geometry.size.width * style.bottomRightPosition.width,
                        y: geometry.size.height * style.bottomRightPosition.height
                    )
                // 자식 뷰들
                content()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    AmbientZStack(style: .calmDark) {
        Text("HyperFocus")
            .font(Font.CommoingSoon.largeTitle)
            .foregroundStyle(.white)
    }
}
