//
//  SettingFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import ComposableArchitecture
import Foundation

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

