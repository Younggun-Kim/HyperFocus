//
//  ToastFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ToastFeature {
    @ObservableState
    public struct State: Equatable {
        public var message: String?
        
        public init(message: String? = nil) {
            self.message = message
        }
    }
    
    public enum Action: Equatable {
        case show(String)
        case dismiss
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .show(message):
                state.message = message
                return .none
            case .dismiss:
                state.message = nil
                return .none
            }
        }
    }
}

