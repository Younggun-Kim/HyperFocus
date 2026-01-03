//
//  VersionUpdateType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/3/26.
//

/// 앱 버전 업데이트 타입
import Foundation

public enum VersionUpdateType: String, Decodable, Equatable {
    case optional = "OPTIONAL"
    case required = "REQUIRED"
    case none = "NONE"
    
    /// 버전 문자열로 업데이트 타입 초기화
    /// - Parameter version: 업데이트 타입 문자열 (대소문자 무시)
    public init?(version: String) {
        let normalized = version.uppercased().trimmingCharacters(in: .whitespaces)
        self.init(rawValue: normalized)
    }
}
