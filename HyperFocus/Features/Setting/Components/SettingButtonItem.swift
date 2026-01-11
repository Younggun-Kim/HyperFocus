//
//  SettingButtonItem.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation
import SwiftUI

public struct SettingButtonItem: View {
    var icon: String
    var iconSize: CGSize
    var title: String
    
    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.systemLightGray.opacity(0.3))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .resizable()
                    .frame(width: iconSize.width, height: iconSize.height)
                    .foregroundColor(.white)
            }
            Text(title)
                .font(.body.bold())
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .frame(width: 13, height: 10)
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    @Previewable @State var isOn = false
    
    SettingButtonItem(
        icon: "figure.2",
        iconSize: .init(width: 28, height: 20),
        title: "Sound",
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
