//
//  RestExtensionResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct RestExtensionResponse: Codable, Sendable, Equatable {
    var id: String // UUID
    var targetDurationSeconds: Int // 목표 시간
    var extensionCount: Int // 연장 횟수
    var remainingExtensions: Int // 남은 연장 횟수
    var canExtend: Bool // 연장 가능 여부
}
