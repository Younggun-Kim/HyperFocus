//
//  DebugAssistant.swift
//  HyperFocus
//
//  Created by 김영건 on 1/8/26.
//

import ComposableArchitecture

public struct DebugConfig {
    // 타이머 재생 속도 (1.0 = 정상 속도, 2.0 = 2배속 등)
    public var playbackRate: Double
    
    // 휴식 타이머 재생 속도
    public var restPlaybackRate: Double
    
    // 테스트 모드 활성화 여부
    public var isTestMode: Bool
    
    public init(
        playbackRate: Double = 50.0,
        restPlaybackRate: Double = 10.0,
        isTestMode: Bool = false
    ) {
        self.playbackRate = playbackRate
        self.restPlaybackRate = restPlaybackRate
        self.isTestMode = isTestMode
    }
    
    // 설정값을 업데이트하는 메서드
    public func with(
        playbackRate: Double? = nil,
        restPlaybackRate: Double? = nil,
        isTestMode: Bool? = nil
    ) -> DebugConfig {
        var updated = self
        
        if let playbackRate = playbackRate {
            updated.playbackRate = playbackRate
        }
        
        if let restPlaybackRate = restPlaybackRate {
            updated.restPlaybackRate = restPlaybackRate
        }
        
        if let isTestMode = isTestMode {
            updated.isTestMode = isTestMode
        }
        
        return updated
    }
}

extension DebugConfig: DependencyKey {
    public static var liveValue = DebugConfig()
    
    public static var testValue = DebugConfig(
        playbackRate: 10.0,  // 테스트 시 빠른 재생
        isTestMode: true
    )
    
    public static var previewValue: DebugConfig {
        testValue
    }
}

public extension DependencyValues {
    var debugConfig: DebugConfig {
        get { self[DebugConfig.self] }
        set { self[DebugConfig.self] = newValue }
    }
}
