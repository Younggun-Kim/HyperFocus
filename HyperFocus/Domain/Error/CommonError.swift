//
//  CommonError.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//


public enum CommonError: Error, Equatable {
    case invalidFormat
    
    
    var localizedDescription: String {
        switch self {
        case .invalidFormat:
            return "유효하지 않은 포맷입니다."
        }
    }
}
