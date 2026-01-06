//
//  RestExtensionEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation


public struct RestExtensionEntity: Codable, Sendable, Equatable {
    var id: String // UUID
    var targetDurationSeconds: Int // 목표 시간
    var extensionCount: Int // 연장 횟수
    var remainingExtensions: Int // 남은 연장 횟수
    var canExtend: Bool // 연장 가능 여부
}


extension RestExtensionEntity {
    static let mock: RestExtensionEntity = .init(
        id: UUID().uuidString,
        targetDurationSeconds: 600,
        extensionCount: 0,
        remainingExtensions: 0,
        canExtend: true,
    )
}
