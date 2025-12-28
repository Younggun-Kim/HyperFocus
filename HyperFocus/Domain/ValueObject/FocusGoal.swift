//
//  FocusGoal.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//

import Foundation


struct FocusGoal: Equatable, Hashable, Codable {
    private(set) var value: String
    
    static let maxLength = 60
    
    init?(_ value: String) {
        guard Self.isValid(value) else {
            return nil
        }
        self.value = value
    }
    
    static func isValid(_ value: String) -> Bool {
        return value.count <= Self.maxLength
    }
}
