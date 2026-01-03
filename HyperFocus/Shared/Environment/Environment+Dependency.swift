//
//  Environment+Dependency.swift
//  HyperFocus
//
//  Created by 김영건 on 1/4/26.
//

import Foundation
import ComposableArchitecture

extension Environment: DependencyKey {
    public static var liveValue: Environment {
        Environment()
    }
    
    public static var testValue: Environment {
        Environment()
    }
    
    public static var previewValue: Environment {
        Environment()
    }
}

public extension DependencyValues {
    var environemnt: Environment {
        get { self[Environment.self] }
        set { self[Environment.self] = newValue }
    }
}
