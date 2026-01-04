//
//  AmplitudeService.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import AmplitudeSwift
import Foundation
import ComposableArchitecture

public struct AmplitudeService {
    public let track: @Sendable (_ event: AmplitudeEvent) -> Void
    public let setDeviceId: @Sendable (_ deviceId: String) -> Void
    public let setUserId: @Sendable (_ userId: String?) -> Void
}

extension AmplitudeService: DependencyKey {
    public static var liveValue: AmplitudeService {
        guard let amplitudeKey = Environment.amplitudeAPIKey else {
            // API Key가 없으면 빈 구현 반환
            return AmplitudeService(
                track: { _ in },
                setDeviceId: { _ in },
                setUserId: { _ in },
            )
        }
        
        let amplitude = Amplitude(configuration: Configuration(
            apiKey: amplitudeKey,
            autocapture: .all
        ))
        
        return AmplitudeService(
            track: { event in
                amplitude.track(
                    eventType: event.key,
                    eventProperties: event.properties
                )
            },
            setDeviceId: { deviceId in
                amplitude.setDeviceId(deviceId: deviceId)
            },
            setUserId: { userId in
                amplitude.setUserId(userId: userId)
            },
        )
    }
}

extension DependencyValues {
    public var amplitudeService: AmplitudeService {
        get { self[AmplitudeService.self] }
        set { self[AmplitudeService.self] = newValue }
    }
}
