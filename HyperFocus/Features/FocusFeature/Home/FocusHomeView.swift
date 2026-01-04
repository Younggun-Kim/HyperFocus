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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            AmbientZStack(style: .black) {
                VStack {
                    Spacer()
                    ReasonEditor
                    ReasonChips
                    DurationChips
                    StartButton
                }
            }
            .ignoresSafeArea(.keyboard)
        } destination: { store in
            switch store.case {
            case let .detail(detailStore):
                FocusDetailView(store: detailStore)
            }
        }
        .onAppear {
            store.send(.viewDidAppear)
        }
        .toast(message: Binding(
            get: { store.toastMessage },
            set: { _ in store.send(.toastDismissed) }
        ))
    }
    
    // MARK: - 목표 입력
    var ReasonEditor: some View {
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
                    CharWrappingText(
                        text: FocusText.goalPlaceholder,
                        font: .preferredFont(forTextStyle: .title1),
                        color: .gray,
                        alignment: .left
                    )
                    .padding(16)
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
    var ReasonChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.reasons, id: \.self) { reason in
                    CommonChip(
                        title: reason.title,
                        style: .gray,
                        selected: false,
                        maxLength: 12,
                        action: {
                            store.send(.reasonChanged(reason))
                        })
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - 타이머 시간
    var DurationChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Spacer()
                ForEach(store.durations, id: \.self) { duration in
                    CommonChip(
                        title: duration.title,
                        style: .grayFill,
                        selected: store.selectedDuration == duration,
                        maxLength: 12,
                        action: {
                            store.send(.durationChanged(duration))
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
        store: Store(
            initialState: FocusHomeFeature.State(
                suggestions: SuggestionEntity.defaultSuggesions,
            )
        ) {
            FocusHomeFeature()
        } withDependencies: {
            $0.focusUseCase = .preview(
                suggestions: SuggestionEntity.defaultSuggesions
            )
        }
    )
}
