//
//  SettingFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
        var soundOn: Bool = false
        var hapticOn: Bool = false
        var alarmOn: Bool = false
    }
    
    enum Action {
        case soundToggled(Bool)
        case hapticToggled(Bool)
        case alarmToggled(Bool)
        case aboutUsTapped(SettingMetadata.AboutUs)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .soundToggled(isOn):
                state.soundOn = isOn
                return .none
            case let .hapticToggled(isOn):
                state.hapticOn = isOn
                return .none
            case let .alarmToggled(isOn):
                state.alarmOn = isOn
                return .none
            case .aboutUsTapped:
                // TODO: Handle navigation or action
                return .none
            }
        }
    }
}

extension StoreOf<SettingFeature> {
    func binding(for setting: SettingMetadata.DeviceSetting) -> Binding<Bool> {
        switch setting {
        case .sound:
            return Binding(
                get: { self.soundOn },
                set: { self.send(.soundToggled($0)) }
            )
        case .haptic:
            return Binding(
                get: { self.hapticOn },
                set: { self.send(.hapticToggled($0)) }
            )
        case .alarm:
            return Binding(
                get: { self.alarmOn },
                set: { self.send(.alarmToggled($0)) }
            )
        }
    }
}

