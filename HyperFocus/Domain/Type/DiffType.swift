//
//  DiffType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

public enum DiffType: Equatable, Sendable {
    case increase
    case decrease
    case same
    case none
    
    public init?(rawValue: String) {
        switch(rawValue) {
        case "INCREASE": self = .increase
        case "DECREASE": self = .decrease
        case "SAME": self = .same
        case "NONE": self = .none
        default: return nil
        }
    }
}
