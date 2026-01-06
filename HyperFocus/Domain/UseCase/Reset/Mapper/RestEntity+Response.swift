//
//  RestEntity+Response.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation

extension RestResponse {
    func toEntity() -> RestEntity? {
        guard let status: SessionStatusType = .init(rawValue: status) else {
            return nil
        }
        
        return .init(
            id: id,
            focusSessionId: focusSessionId,
            targetDurationSeconds: targetDurationSeconds,
            actualDurationSeconds: actualDurationSeconds,
            extensionCount: extensionCount,
            remainingExtensions: remainingExtensions,
            canExtend: canExtend,
            status: status,
            startedAt: startedAt,
            completedAt: completedAt
        )
    }
}
