//
//  Project+Templates.swift
//  Config
//
//  Created by 김영건 on 11/30/25.
//

import ProjectDescription

extension Project {
  public static func make(
    name: String,
    organizationName: String = "com.conner.HyperFocus",
    options: Options = .options(
      automaticSchemesOptions: .disabled,
      defaultKnownRegions: ["ko"],
      developmentRegion: "ko",
      textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
    ),
    packages: [Package] = [],
    settings: Settings? = nil,
    targets: [Target] = [],
    schemes: [Scheme] = [],
    fileHeaderTemplate: FileHeaderTemplate? = nil,
    additionalFiles: [FileElement] = [],
    resourceSynthesizers: [ResourceSynthesizer] = .default
  ) -> Project {
    Project(
      name: name,
      organizationName: organizationName,
      options: options,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes,
      fileHeaderTemplate: fileHeaderTemplate,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}
