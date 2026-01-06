//
//  RestSkipEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation


public struct RestSkipEntity: Codable, Sendable, Equatable {
    var id: String // UUID
    var status: RestStatusType // 상태
    var completedAt: Date? // 완료 시간
}


extension RestSkipEntity {
    static let mock: RestSkipEntity = .init(
        id: UUID().uuidString,
        status: .skipped,
        completedAt: nil
    )
}
