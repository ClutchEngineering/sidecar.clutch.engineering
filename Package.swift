// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "sidecar.clutch.engineering",
  platforms: [
    .macOS("14")
  ],
  dependencies: [
    .package(url: "https://github.com/jverkoey/slipstream.git", branch: "main"),
  ],
  targets: [
    .executableTarget(name: "analytics"),

    .executableTarget(name: "gensite", dependencies: [
      .product(name: "Slipstream", package: "slipstream"),
      "VehicleSupport",
    ], resources: [
      .process("export-carplay-distance-traveled-by-model-yesterday.csv"),
      .process("export-carplay-distance-traveled-by-model.csv"),
      .process("export-carplay-drivers-by-model.csv"),
    ]),

    .executableTarget(name: "export", dependencies: [
      "VehicleSupport",
    ]),

    .executableTarget(name: "import", dependencies: [
      "VehicleSupport",
    ]),

    .target(name: "VehicleSupport", resources: [
      .process("supportmatrix.json")
    ])
  ]
)
