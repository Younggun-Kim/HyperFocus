//
//  RestExtensionEntity+Response.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation

extension RestExtensionResponse {
    func toEntity() -> RestExtensionEntity {
        
        return .init(
            id: id,
            targetDurationSeconds: targetDurationSeconds,
            extensionCount: extensionCount,
            remainingExtensions: remainingExtensions,
            canExtend: canExtend,
        )
    }
}
