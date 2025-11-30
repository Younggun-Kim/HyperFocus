import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DesignSystem",
  targets: [
    .make(
      name: TargetName.designSystem.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.DesignSystem",
      sources: ["Sources/**"],
      resources: ["Resources/**"]
    )
  ]
)
