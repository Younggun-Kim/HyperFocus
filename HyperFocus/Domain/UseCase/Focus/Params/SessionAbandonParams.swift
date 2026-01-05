//
//  SessionAbandonParams.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//

import Foundation


public struct SessionAbandonParams: Sendable {
    var actualDurationSeconds: Int
    var failReason: String?
}
