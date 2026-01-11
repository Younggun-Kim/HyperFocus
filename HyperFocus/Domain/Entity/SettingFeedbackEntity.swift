//
//  SettingFeedbackEntity.swift
//  HyperFocus
//
//  Created by 김영건 on 1/12/26.
//

import Foundation

public struct SettingFeedbackEntity: Codable, Equatable, Sendable {
    public let id: String
    public let category: String
    public let textLength: Int
    public let createdAt: Date
}

extension SettingFeedbackEntity {
    static var mock: SettingFeedbackEntity {
        .init(
            id: UUID().uuidString,
            category: "bug",
            textLength: 100,
            createdAt: Date()
        )
    }
}
