//
//  Target+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영건 on 11/30/25.
//

import Foundation
import ProjectDescription

fileprivate let commonScripts: [TargetScript] = [
  .pre(
    script: """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
    DEFAULT_ROOT_DIR="$(pwd)/../.."
    RESOLVED_ROOT_DIR="${ROOT_DIR:-$DEFAULT_ROOT_DIR}"

    SWIFTLINT_PATH="${RESOLVED_ROOT_DIR}/swiftlint"

    if ! [ -x "$SWIFTLINT_PATH" ]; then
      SWIFTLINT_PATH="$(command -v swiftlint || true)"
    fi

    if [ -z "$SWIFTLINT_PATH" ]; then
      echo "warning: SwiftLint not installed. Skipping lint." >&2
      exit 0
    fi

    CONFIG_PATH="${RESOLVED_ROOT_DIR}/.swiftlint.yml"
    CONFIG_ARGUMENT=""

    if [ -f "$CONFIG_PATH" ]; then
      CONFIG_ARGUMENT="--config ${CONFIG_PATH}"
    else
      echo "warning: .swiftlint.yml not found at ${CONFIG_PATH}. Running with default configuration." >&2
    fi

    "$SWIFTLINT_PATH" ${CONFIG_ARGUMENT}

    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
]

extension Target {
  public static func make(
    name: String,
    destinations: Destinations = [.iPhone],
    product: Product,
    productName: String? = nil,
    bundleId: String,
    deploymentTargets: DeploymentTargets? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList,
    resources: ResourceFileElements? = nil,
    copyFiles: [CopyFilesAction]? = nil,
    headers: Headers? = nil,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
    coreDataModels: [CoreDataModel] = [],
    environmentVariables: [String: EnvironmentVariable] = [:],
    launchArguments: [LaunchArgument] = [],
    additionalFiles: [FileElement] = [],
    buildRules: [BuildRule] = [],
    mergedBinaryType: MergedBinaryType = .disabled,
    mergeable: Bool = false
  ) -> Target {
    return .target(
      name: name,
      destinations: destinations,
      product: product,
      productName: productName,
      bundleId: bundleId,
      deploymentTargets: .iOS("17.0"),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      copyFiles: copyFiles,
      headers: headers,
      entitlements: entitlements,
      scripts: commonScripts + scripts,
      dependencies: dependencies,
      settings: settings,
      coreDataModels: coreDataModels,
      environmentVariables: environmentVariables,
      launchArguments: launchArguments,
      additionalFiles: additionalFiles,
      buildRules: buildRules,
      mergedBinaryType: mergedBinaryType,
      mergeable: mergeable
    )
  }
}
