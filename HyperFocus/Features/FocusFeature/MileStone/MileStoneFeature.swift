//
//  MileStoneFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MileStoneFeature {
    @Dependency(\.focusUseCase) var focusUseCase
    
    @ObservableState
    public struct State: Equatable {
        public var message: String?
        
        public init(message: String? = nil) {
            self.message = message
        }
    }
    
    @CasePathable
    public enum Action {
        case show(String, Int) // sessionId, minute
        case dismiss
        case setMessage(String?)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .show(sessionId, minute):
                return .run{ send in
                    do {
                        let response = try await self.focusUseCase.getMileStone(
                            sessionId, minute
                        )
                        await send(.setMessage(response?.message))
                    } catch {}
                }
            case .dismiss:
                state.message = nil
                return .none
            case .setMessage(let message):
                state.message = message
                
                return .none
            }
        }
    }
}

