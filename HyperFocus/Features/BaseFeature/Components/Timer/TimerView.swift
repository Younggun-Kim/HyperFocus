//
//  Timer.swift
//  HyperFocus
//
//  Created by 김영건 on 12/26/25.
//

import ComposableArchitecture
import SwiftUI

struct TimerView: View {
    @Bindable var store: StoreOf<TimerFeature>
    
    var body: some View {
        ZStack {
            // 원형 진행 링
            ZStack {
                // 배경 링 (전체 원)
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 80)
                
                // 진행 링 (파란색 호)
                Circle()
                    .trim(from: 1 - store.progress, to: 1)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 60/255, green: 211/255, blue: 254/255, opacity: 0.80),
                                Color(red: 60/255, green: 211/255, blue: 254/255, opacity: 0.24)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(
                            lineWidth: 80,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: Color.blue.opacity(0.5), radius: 10)
            }
            .padding(40)
            
            // 중앙 텍스트
            Text(store.timeString)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .frame(width: 300, height: 300)
        .onAppear {
            store.send(.start)
        }
    }
}

#Preview {
    TimerView(
        store: Store(initialState: TimerFeature.State()) {
            TimerFeature()
        }
    )
}
