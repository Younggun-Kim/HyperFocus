//
//  FocusDetailView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusDetailView: View {
    @Bindable var store: StoreOf<FocusDetailFeature>
    
    var body: some View {
        AmbientZStack(style: .blueDark) {
            VStack(){
                TimerView(
                    store: store.scope(state: \.timer, action: \.timer)
                )
                .padding(.top, 86)
                Spacer()
                HStack(alignment: .bottom, spacing: 30) {
                    Image("ic_check")
                    if store.timer.isRunning {
                        Image("ic_pause")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.playToggled)
                            }
                        
                    } else {
                        Image(Assets.icPlay.rawValue)
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.playToggled)
                            }
                    }
                    Image(store.isSoundOn ? "ic_sound":"ic_sound_mute")
                        .onTapGesture {
                            store.send(.sounctToggled)
                        }
                }
                .padding(.bottom, 113)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    FocusDetailView(
        store: Store(initialState: FocusDetailFeature.State(
            timer: TimerFeature.State(),
            focusGoal: FocusGoal("테스트 목표")!,
            focusTime: .oneHour,
            
        )) {
            FocusDetailFeature()
        }
    )
}
