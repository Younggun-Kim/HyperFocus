//
//  InputMethodType.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation

public enum InputMethodType: String, Codable {
    case chip // 추천을 눌러서 설정
    case manual // 유저가 직접 다이얼, 키패드로 입력
}
