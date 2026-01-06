//
//  RestEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation


public struct RestEntity: Codable, Sendable, Equatable {
    var id: String // UUID
    var focusSessionId: String // UUID
    var targetDurationSeconds: Int // 목표 시간
    var actualDurationSeconds: Int // 실제 경과 시간
    var extensionCount: Int // 연장 횟수
    var remainingExtensions: Int // 남은 연장 횟수
    var canExtend: Bool // 연장 가능 여부
    var status: RestStatusType // 상태
    var startedAt: Date // 시작 시간
    var completedAt: Date? // 완료 시간
}


extension RestEntity {
    var elapsedSeconds: Int {
        targetDurationSeconds - actualDurationSeconds
    }
    static let mock: RestEntity = .init(
        id: UUID().uuidString,
        focusSessionId: UUID().uuidString,
        targetDurationSeconds: 600,
        actualDurationSeconds: 0,
        extensionCount: 0,
        remainingExtensions: 0,
        canExtend: true,
        status: .inProgress,
        startedAt: .init(),
        completedAt: nil
    )
}
