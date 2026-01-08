//
//  DiffType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/9/26.
//

public enum DiffType: String, Equatable, Sendable, Codable{
    case increase = "INCREASE"
    case decrease = "DECREASE"
    case same = "SAME"
    case none = "NONE"
    
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
