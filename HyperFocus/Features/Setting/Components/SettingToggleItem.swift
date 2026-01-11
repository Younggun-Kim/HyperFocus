//
//  SettingToggleItem.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation
import SwiftUI

public struct SettingToggleItem: View {
    var icon: String
    var iconSize: CGSize
    var title: String
    @Binding var isOn: Bool
 
    public var body: some View {
        Toggle(isOn: $isOn, label: {
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
            }
        })
        .toggleStyle(CustomToggleStyle())
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        configuration.isOn
                        ? Color.systemBlue
                        : Color.systemLightGray
                    )
                    .frame(width: 64, height: 28)
                
                Circle()
                    .fill(.black)
                    .frame(width: 39, height: 24)
                    .background(.black)
                    .cornerRadius(50)
                    .padding(2)
            }
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isOn = false
    
    SettingToggleItem(
        icon: SettingMetadata.DeviceSetting.sound.icon,
        iconSize: SettingMetadata.DeviceSetting.sound.iconSize,
        title: SettingMetadata.DeviceSetting.sound.title,
        isOn: $isOn
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
