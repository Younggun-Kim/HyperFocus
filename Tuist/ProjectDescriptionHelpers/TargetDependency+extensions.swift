//
//  TargetDependency+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영건 on 11/30/25.
//

import Foundation
import ProjectDescription

extension TargetDependency {
    public static func external(externalDependency: ExternalDependency) -> TargetDependency {
        return .external(name: externalDependency.rawValue)
    }
    
    public static func target(name: TargetName) -> TargetDependency {
        return .target(name: name.rawValue)
    }
    
    public static func project(target: TargetName, projectPath: ProjectPath) -> TargetDependency {
        return .project(
            target: target.rawValue,
            path: .relativeToRoot(projectPath.rawValue)
        )
    }
}

public enum ProjectPath: String {
    case core = "Projects/Core"
    case shared = "Projects/Shared"
}

public enum TargetName: String {
    case app = "App"
    case common = "Common"
    case designSystem = "DesignSystem"
}

public enum ExternalDependency: String {
    case lottie = "Lottie"
}
