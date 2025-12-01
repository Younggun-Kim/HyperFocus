//
//  Project.swift
//  Config
//
//  Created by 김영건 on 12/1/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "App",
  targets: [
    .make(
      name: TargetName.app.rawValue,
      product: .app,
      bundleId: "com.conner.HyperFocus.App",
      sources: ["Sources/**"],
      dependencies: [
        .project(target: .common, projectPath: .core),
        .project(target: .designSystem, projectPath: .shared),
      ]
    ),
  ]
)
