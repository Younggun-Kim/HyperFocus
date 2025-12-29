//
//  FocusView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import ComposableArchitecture
import SwiftUI

struct FocusHomeView: View {
    @Bindable var store: StoreOf<FocusHomeFeature>
    @FocusState private var isGoalFocused: Bool
    
    var body: some View {
        NavigationView {
            AmbientZStack(style: .black) {
                
                VStack {
                    Spacer()
                    GoalEditor
                    ExampleGoals
                    BasicTimePicker
                    StartButton
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    // MARK: - 목표 입력
    var GoalEditor: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $store.inputText.sending(\.inputTextChanged))
                    .focused($isGoalFocused)
                    .autocorrectionDisabled(true)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: .infinity)
                    .padding(16)
                    .font(.title)
                    .foregroundStyle(Color.systemBlue)
                    .multilineTextAlignment(.leading)
                
                if store.inputText.isEmpty {
                    Text(FocusText.goalPlaceholder)
                        .font(.title)
                        .foregroundStyle(.gray)
                        .padding(18)
                        .allowsHitTesting(false)
                }
            }
            
            Button(action: {
                self.isGoalFocused = false
                HapticUtils.impact(style: .medium)
                store.send(.addBtnTapped)
            }) {
                Text(FocusText.add)
                    .font(.caption.bold())
                    .foregroundStyle(
                        store.inputText.isEmpty ?
                        Color.systemGray
                        : Color.systemBlue
                    )
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
        }
        .frame(maxHeight: 130)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(16)
        .padding(.horizontal, 24)
    }
    
    // MARK: - 목표 예시
    var ExampleGoals: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.recommendGoals, id: \.self) { goal in
                    CommonChip(
                        title: goal,
                        style: .gray,
                        selected: false,
                        action: {
                            store.send(.exampleGoalTapped(goal))
                        })
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - 타이머 시간
    var BasicTimePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Spacer()
                ForEach(BasicTime.allCases, id: \.self) { type in
                    CommonChip(
                        title: type.title,
                        style: .grayFill,
                        selected: store.goalTime == type,
                        action: {
                            store.send(.timeChanged(type))
                        }
                    )
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: 시작 버튼
    var StartButton: some View {
        Image(AssetSystem.icPlay.rawValue)
            .gesture(TapGesture().onEnded{ _ in
                HapticUtils.impact(style: .medium)
                store.send(.addBtnTapped)
            })
            .padding(.top, 78)
            .padding(.bottom, 52)
    }
}

#Preview {
    FocusHomeView(
        store: Store(initialState: FocusHomeFeature.State()) {
            FocusHomeFeature()
        }
    )
}

