//
//  OnboardingTimerView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/26/25.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingTimerView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    @State private var ambientStyle: AmbientStyleType = .all282828
    @State private var offset = CGSize(width: 0, height: 0)
    @State private var titleOffset: CGFloat = 0
    @State private var showText: Bool = false
    
    var body: some View {
        AmbientZStack(style: ambientStyle, alignment: .top) {
            VStack{
                Text(BaseText.onboardingTimerTitle)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 200)
                Text(BaseText.onboardingTimerDescription)
                    .font(.body)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showText ? 1 : 0)
                if !showText {
                    Spacer()
                } else {
                    Spacer()
                    if let timerStore = store.scope(state: \.timer, action: \.timer) {
                        TimerView(store: timerStore)
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .gesture(TapGesture().onEnded({ _ in
            withAnimation(.easeInOut(duration: 1)) {
                self.ambientStyle = .black
                self.showText = true
            }
            // Timer 초기화
            store.send(.initializeTimer)
        }))
    }
}

#Preview {
    OnboardingTimerView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
