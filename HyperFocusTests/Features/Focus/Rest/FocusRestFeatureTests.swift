//
//  FocusRestFeatureTests.swift
//  HyperFocusTests
//
//  Created by 김영건 on 1/6/26.
//

import Testing
import ComposableArchitecture
@testable import HyperFocus
import Foundation

@Suite("FocusRestFeature 테스트")
struct FocusRestFeatureTests {
    
    @Test("State 초기화 - 기본값 확인")
    func testInitialState() {
        let state = FocusRestFeature.State()
        
        #expect(state.timer.remainingSeconds == 25 * 60)
        #expect(state.timer.isRunning == false)
        #expect(state.toast.message == nil)
    }
    
    @Test("onAppear 액션 처리 - 상태 변경 없음 확인")
    func testOnAppearAction() async {
        let store = await TestStore(initialState: FocusRestFeature.State()) {
            FocusRestFeature()
        }
        
        await store.send(.inner(.onAppear)) { state in
            // onAppear는 상태를 변경하지 않음
        }
    }
    
    @Test("timer 액션 처리 - timerTick 액션 확인")
    func testTimerAction() async {
        let store = await TestStore(initialState: FocusRestFeature.State()) {
            FocusRestFeature()
        }
        
        await store.send(.timer(.timerTick)) { state in
            // timerTick은 현재 상태를 변경하지 않음
        }
    }
}
