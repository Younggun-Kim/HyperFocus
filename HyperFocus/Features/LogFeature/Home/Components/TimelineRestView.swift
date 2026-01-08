//
//  TimelineRestView.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

import SwiftUI

struct TimelineRestView: View {
    var restMinute: Int
    
    private var isRest10Min: Bool {
        restMinute > 10
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Color.systemLightGray
                .frame(maxWidth: 8)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.systemGray)
                if isRest10Min {
                    Text("+\(restMinute)m")
                        .font(.caption)
                        .foregroundStyle(Color.systemGray)
                }
            }
            .padding(.vertical, 10)
            Spacer()
        }
        .frame(height: isRest10Min ? 90 : 32)
    }
    
    private var title: String {
        if restMinute <= 10 {
            return "Skil Cooldown Ticking"
        } else if restMinute <= 30 {
            return "Spacing out (It's a talent)"
        } else if restMinute <= 60 {
            return "Catching my breath"
        }
        
        return "Brain Reboot Complete"
    }
}

#Preview {
    TimelineRestView(
        restMinute: 10
    )
    .background(.black)
}
