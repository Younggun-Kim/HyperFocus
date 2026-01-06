//
//  RestResponse.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct RestResponse: Codable, Sendable, Equatable {
    var id: String // UUID
    var focusSessionId: String // UUID
    var targetDurationSeconds: Int // 목표 시간
    var actualDurationSeconds: Int // 실제 경과 시간
    var extensionCount: Int // 연장 횟수
    var remainingExtensions: Int // 남은 연장 횟수
    var canExtend: Bool // 연장 가능 여부
    var status: String  // IN_PROGRESS, COMPLETED, SKIPPED
    var startedAt: Date // 시작 시간
    var completedAt: Date? // 완료 시간
}
