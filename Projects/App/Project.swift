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
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.App",
      sources: ["Sources/**"]
    ),
  ]
)
