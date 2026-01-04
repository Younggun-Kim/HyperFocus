//
//  SessionStartRequest.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation


public struct SessionStartRequest: Codable, Sendable, Equatable {
    var name: String?
    var targetDurationSeconds: Int // Seconds
    var inputMethod: String? // CHIP, MANUAL
    
    // TODO: - 어떤 값이 들어가야 하는가
    var ambientSound: String?
}
