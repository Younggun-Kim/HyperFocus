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
    @Dependency(\.amplitudeService) var amplitudeService
    
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
        case setMessage(MileStoneEntity?)
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
                        await send(.setMessage(response))
                    } catch {}
                }
            case .dismiss:
                state.message = nil
                return .none
            case .setMessage(let milestone):
                state.message = milestone?.message
                
                if  let id = milestone?.messageId,
                    let minute = milestone?.milestoneMinute {
                    amplitudeService.track(.viewMotivationToast(.init(id: id, minute: minute)))
                }
                
                return .none
            }
        }
    }
}

