//
//  LogHomeView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI
import ComposableArchitecture

struct LogHomeView: View {
    @Bindable var store: StoreOf<LogHomeFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ZStack(alignment: .topLeading) {
                Color.black
                    .ignoresSafeArea(edges: .all)
                ScrollView {
                    VStack {
                        HeaderView
                        WeekDataView
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                        TimelineView
                    }
                }
            }
            .onAppear {
                store.send(.inner(.onAppear))
            }
            .toast(message: Binding(
                get: { store.toast.message },
                set: { _ in store.send(.scope(.toast(.dismiss))) }
            ))
        } destination: { store in
            switch store.case {
            case let .setting(settingStore):
                SettingView(store: settingStore)
            }
        }
    }
    
    var HeaderView: some View {
        HStack {
            Text("HyperFocus")
                .font(Font.CommoingSoon.title)
                .foregroundStyle(.white)
            Spacer()
            Button(action: {
                store.send(.inner(.settingTapped))
            }) {
                Image(AssetSystem.icSetting.rawValue)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    var WeekDataView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Today`s Flow")
                    .foregroundStyle(Color.systemGray)
                    .font(.caption)
                    .padding(.trailing, 40)
                    .padding(.vertical, 6)
                if store.isEmpty || store.todayFocus.isEmpty {
                    Text("Ready")
                        .foregroundStyle(Color.systemGray)
                        .font(.largeTitle)
                    Spacer()
                } else {
                    Spacer()
                    Text(store.todayFocus)
                        .foregroundStyle(Color.systemBlue)
                        .font(.largeTitle)
                        .lineHeight(.tight)
                }
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Total Focus")
                        .foregroundStyle(Color.systemGray)
                        .font(.caption)
                        .padding(.trailing, 40)
                        .padding(.vertical, 6)
                    if !store.diffMessage.isEmpty {
                        Text(store.diffMessage)
                            .foregroundStyle(Color.white)
                            .font(.caption)
                    }
                }
                Spacer()
                if !store.weekTotal.isEmpty {
                    Text(store.weekTotal)
                        .foregroundStyle(Color.white)
                        .font(.title.bold())
                        .lineHeight(.tight)
                        .padding(.vertical, 3)
                }
            }
//            .padding(.top, 8)
            .padding(.bottom, 13)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(Color.systemLightGray.opacity(0.3))
        .cornerRadius(24)
    }
    
    @ViewBuilder
    var TimelineView: some View {
        if store.isEmpty {
            TimelineEmptyView
        } else {
            TimelineListView
        }
    }
    
    var TimelineEmptyView: some View {
        VStack(alignment: .center) {
            Image(AssetSystem.arrowDown.rawValue)
                .frame(width: 147, height: 147)
            Text("Fill this track with your flow.")
                .foregroundStyle(Color.systemBlue)
                .font(.title)
                .padding(.top, 35)
                .padding(.bottom, 10)
            Button(action: {
                store.send(.delegate(.startFocus))
            }) {
                Text("Start")
                    .font(.title3)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.systemBlue)
                    )
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 80)
    }
    
    var TimelineListView: some View {
        VStack(spacing: 0) {
            ForEach(store.timelines.filter{
                if $0.type == .gap {
                    return $0.durationSeconds >= 60
                }
                
                return true
            }, id: \.self) { timeline in
                if timeline.type == .focus {
                    TimelineFocusView(
                        time: timeline.focusDuration,
                        text: timeline.name ?? "No title",
                        isNew: timeline.isNew ?? false
                    )
                } else {
                    TimelineRestView(
                        restMinute: timeline.durationMinutes
                    )
                }
            }
        }
        .padding(.vertical, 45)
        .padding(.horizontal, 24)
    }
}

#Preview {
    LogHomeView(
        store: Store(initialState: LogHomeFeature.State()) {
            LogHomeFeature()
        } withDependencies: {
            $0.logUseCase = .testValue
        }
    )
}
