//
//  RestEntity+Response.swift
//  HyperFocus
//
//  Created by 김영건 on 1/7/26.
//

import Foundation

extension RestSkipResponse {
    func toEntity() -> RestSkipEntity? {
        guard let status: RestStatusType = .init(rawValue: status) else {
            return nil
        }
        
        return .init(
            id: id,
            status: status,
            completedAt: completedAt
        )
    }
}
