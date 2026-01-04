//
//  SessionAbandonRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct SessionAbandonRequest: Codable, Sendable, Equatable {
    var actualDurationSeconds: Int
    var failReason: String?
}
