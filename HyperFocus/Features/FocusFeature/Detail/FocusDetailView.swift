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
    @State private var showPopover = false
    
    
    
    var body: some View {
        AmbientZStack(style: .blueDark) {
            VStack(){
                TimerView(
                    store: store.scope(state: \.timer, action: \.timer)
                )
                .padding(.top, 86)
                Spacer()
                HStack(alignment: .bottom, spacing: 30) {
                    Image(AssetSystem.icCheck.rawValue)
                        .onTapGesture {
                            showPopover.toggle()
                        }
                        .customAlert(
                            isPresented: $showPopover,
                            params: CustomAlertParams(
                                title: FocusText.WrapUpAlert.title,
                                btns: [
                                    CustomAlertBtnModel(
                                        title: FocusText.WrapUpAlert.save,
                                        style: .blue,
                                        action: {}),
                                    CustomAlertBtnModel(
                                        title: FocusText.WrapUpAlert.resume,
                                        style: .gray,
                                        action: {}),
                                    CustomAlertBtnModel(
                                        title: FocusText.WrapUpAlert.delete,
                                        style: .grayRed,
                                        action: {
                                            showPopover.toggle()
                                        })
                                ]
                            )
                        )
                    
                    if store.timer.isRunning {
                        Image(AssetSystem.icPause.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.playToggled)
                            }
                        
                    } else {
                        Image(AssetSystem.icPlay.rawValue)
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.playToggled)
                            }
                    }
                    Image(store.isSoundOn
                          ? AssetSystem.icSound.rawValue
                          : AssetSystem.icSoundMute.rawValue
                    )
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
