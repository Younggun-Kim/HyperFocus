//
//  SettingResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation

public struct SettingResponse: Decodable, Equatable, Sendable {
    public let soundEnabled: Bool
    public let hapticEnabled: Bool
    public let alarmEnabled: Bool
}
