//
//  ChangeAppSettingProps.swift
//  HyperFocus
//
//  Created by 김영건 on 1/5/26.
//
import Foundation


public struct ChangeAppSettingProps: Codable {
    let settingName: String
    
    func toDictionary() -> [String: Any] {
        [
            "setting_name": self.settingName,
        ]
    }
}
