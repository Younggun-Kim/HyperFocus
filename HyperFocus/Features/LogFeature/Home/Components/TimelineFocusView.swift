//
//  TimelineFocusView.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import SwiftUI

struct TimelineFocusView: View {
    var time: String
    var text: String
    var isNew: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Color.systemBlue
                .frame(maxWidth: 8)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(time)
                        .font(.body)
                        .foregroundStyle(.white)
                    Spacer()
                    if isNew {
                        CommonChip(
                            title: "New",
                            style: .grayFill,
                            selected: true,
                            action: {}
                        )
                    }
                }
                Text(text)
                    .font(.title)
                    .foregroundStyle(Color.systemBlue)
                    .lineLimit(3)
            }
            .padding(.vertical, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 140)
    }
}

#Preview {
    TimelineFocusView(
        time: "15:55 - 16:00 (5m)",
        text: "Reading Book Sahras hdifj eifjdifowkdjfoeifjk foeifjiefj fdfsfsfsdfsdw",
        isNew: true
    )
    .background(.black)
}
