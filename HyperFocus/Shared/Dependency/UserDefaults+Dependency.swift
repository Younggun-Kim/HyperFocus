//
//  UserDefaults+Dependency.swift
//  HyperFocus
//
//  Created by 김영건 on 12/30/25.
//


import Dependencies
import Foundation

extension UserDefaults: @unchecked @retroactive Sendable {}

extension UserDefaults: @retroactive TestDependencyKey {}
extension UserDefaults: @retroactive DependencyKey {
  public static var liveValue: UserDefaults = UserDefaults.standard
}

public extension DependencyValues {
  var userDefaults: UserDefaults {
    get { self[UserDefaults.self] }
    set { self[UserDefaults.self] = newValue }
  }
}
