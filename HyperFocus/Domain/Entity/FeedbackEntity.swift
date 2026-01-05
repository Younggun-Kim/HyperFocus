//
//  FeedbackEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct FeedbackEntity: Codable, Sendable, Equatable {
    var id: String // UUID
    var satisfaction: SatisfactionType
    var message: String
}


extension FeedbackEntity {
    static var mock: FeedbackEntity {
        .init(
            id: UUID().uuidString,
            satisfaction: .good,
            message: "잘하고 있어요"
        )
    }
}
