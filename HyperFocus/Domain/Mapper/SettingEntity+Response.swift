//
//  SettingEntity+Response.swift
//  HyperFocus
//
//  Created by 김영건 on 1/11/26.
//

import Foundation


extension SettingResponse {
    func toEntity() -> SettingEntity {
        SettingEntity(
            soundEnabled: soundEnabled,
            hapticEnabled: hapticEnabled,
            alarmEnabled: alarmEnabled
        )
    }
}

extension FeedbackResponse {
    func toEntity() -> SettingFeedbackEntity {
        SettingFeedbackEntity(
            id: id,
            category: category,
            textLength: textLength,
            createdAt: createdAt
        )
    }
}
