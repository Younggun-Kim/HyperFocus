import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Shared",
  targets: [
    .make(
      name: TargetName.designSystem.rawValue,
      product: .staticLibrary,
      bundleId: "com.conner.HyperFocus.Shared.DesignSystem",
      sources: ["DesignSystem/Sources/**"],
      resources: ["DesignSystem/Resources/**"]
    )
  ]
)
