//
//  FocusRestView.swift
//  HyperFocus
//
//  Created by 김영건 on 1/6/26.
//

import SwiftUI
import ComposableArchitecture

struct FocusRestView: View {
    @Bindable var store: StoreOf<FocusRestFeature>
    
    var body: some View {
        AmbientZStack(style: .calmDark) {
            VStack(){
                TimerView(
                    store: store.scope(state: \.timer, action: \.timer)
                )
                .padding(.top, 86)
                Spacer()
                HStack(alignment: .bottom, spacing: 30) {
                    Image(AssetSystem.icCheck.rawValue)
                        .onTapGesture {
                            store.send(.inner(.checkTapped))
                        }
                    
                    if store.timer.isRunning {
                        Image(AssetSystem.icPause.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.inner(.stop))
                            }
                        
                    } else {
                        Image(AssetSystem.icPlay.rawValue)
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                store.send(.inner(.start))
                            }
                    }
                    Image(AssetSystem.icSkip.rawValue)
                    .onTapGesture {
                        store.send(.inner(.skip))
                    }
                }
                .padding(.bottom, 113)
            }
        }
        .onAppear {
            store.send(.inner(.onAppear))
        }
        .navigationBarBackButtonHidden()
        .toolbar(store.tabBarVisibility, for: .tabBar)
        .customAlert(
            isPresented: Binding(
                get: { store.showCompletionPopup },
                set: { _ in store.send(.inner(.completionPopupDismissed)) }
            ),
            params: CustomAlertParams(
                title: String(format: FocusText.RestCompletion.title, store.session.name ?? ""),
                btns: [
                    CustomAlertBtnModel(
                        title: FocusText.RestCompletion.resumeFlow,
                        style: .blue,
                        action: {
                        }),
                    CustomAlertBtnModel(
                        title: FocusText.RestCompletion.startNextTask,
                        style: .gray,
                        action: {
                            store.send(.inner(.startNextTaskTapped))
                        }),
                    CustomAlertBtnModel(
                        title: FocusText.RestCompletion.fiveMinuteBreak,
                        style: .gray,
                        action: {
                        })
                ]
            )
        )
        .toast(message: Binding(
            get: { store.toast.message },
            set: { _ in store.send(.toast(.dismiss)) }
        ))
    }
}

#Preview {
    FocusRestView(
        store: Store(initialState: FocusRestFeature.State(
            session: SessionEntity.mock
        )) {
            FocusRestFeature()
        }
    )
}
