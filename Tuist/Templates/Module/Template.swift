import ProjectDescription

let template = Template(
  description: "Default module template for HyperFocus",
  attributes: [
    .required("name"),
    .optional("bundleIdPrefix", default: "com.conner.HyperFocus"),
  ],
  items: [
    .file(path: "Projects/{{ name }}/Project.swift", templatePath: "Project.stencil"),
    .file(path: "Projects/{{ name }}/Sources/{{ name }}.swift", templatePath: "Sources.stencil"),
    .file(path: "Projects/{{ name }}/Resources/.gitkeep", templatePath: "Resources.stencil")
  ]
)
