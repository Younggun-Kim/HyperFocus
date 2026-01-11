//
//  SettingEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation

public struct SettingEntity: Decodable, Equatable, Sendable {
    public let soundEnabled: Bool
    public let hapticEnabled: Bool
    public let alarmEnabled: Bool
}


extension SettingEntity {
    static var mock: SettingEntity {
        .init(soundEnabled: true, hapticEnabled: true, alarmEnabled: true)
    }
}
