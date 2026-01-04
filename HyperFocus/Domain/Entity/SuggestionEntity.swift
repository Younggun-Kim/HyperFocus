//
//  SuggestionEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SuggestionEntity: Sendable {
    var duration: DurationType
    var reason: ReasonType
    var rank: Int // 정렬 순서 (1이 최상위)
}

public extension SuggestionEntity {
    static let defaultSuggesions: [SuggestionEntity] = [
        .init(duration: .min25, reason: .readingBook, rank: 1),
        .init(duration: .min25, reason: .homework, rank: 2),
        .init(duration: .min25, reason: .running, rank: 3),
    ]
}
