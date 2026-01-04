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
                    Image(AssetSystem.icCheck.rawValue)
                        .onTapGesture {
                            store.send(.checkTapped)
                        }
                    
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
        .customAlert(
            isPresented: Binding(
                get: { store.showWrappingUpAlert },
                set: { _ in store.send(.wrappingUpAlertDismissed) }
            ),
            params: CustomAlertParams(
                title: FocusText.WrapUpAlert.title,
                btns: [
                    CustomAlertBtnModel(
                        title: FocusText.WrapUpAlert.save,
                        style: .blue,
                        action: {
                            store.send(.saveAndComplete)
                        }),
                    CustomAlertBtnModel(
                        title: FocusText.WrapUpAlert.resume,
                        style: .gray,
                        action: {
                            store.send(.resumeTimer)
                        }),
                    CustomAlertBtnModel(
                        title: FocusText.WrapUpAlert.delete,
                        style: .grayRed,
                        action: {
                            store.send(.deleteProgress)
                        })
                ]
            )
        )
        .customAlert(
            isPresented: Binding(
                get: { store.showEarlyWrappingUpAlert },
                set: { _ in store.send(.earlyWrappingUpAlertDismissed) }
            ),
            params: CustomAlertParams(
                title: FocusText.EarlyWrapUpAlert.title,
                description: FocusText.EarlyWrapUpAlert.description,
                btns: [
                    CustomAlertBtnModel(
                        title: FocusText.EarlyWrapUpAlert.keep,
                        style: .blue,
                        action: {
                            store.send(.earlyWrappingUpAlertDismissed)
                            store.send(.resumeTimer)
                        }
                    ),
                    CustomAlertBtnModel(
                        title: FocusText.EarlyWrapUpAlert.delete,
                        style: .grayRed,
                        action: {
                            store.send(.deleteProgress)
                        }
                    )
                ]
            )
        )
        .sheet(isPresented: Binding(
            get: { store.showCompletedBottomSheet },
            set: { _ in store.send(.completedBottomSheetDismissed) }
        )) {
            FocusCompletedBottomSheet(
                store: store.scope(state: \.completed, action: \.completed)
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    FocusDetailView(
        store: Store(initialState: FocusDetailFeature.State(
            timer: TimerFeature.State(),
            focusTime: .min60,
        )) {
            FocusDetailFeature()
        }
    )
}
