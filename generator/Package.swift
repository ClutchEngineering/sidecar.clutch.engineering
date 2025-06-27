// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "sidecar.clutch.engineering",
  platforms: [
    .macOS(.v15)
  ],
  dependencies: [
    .package(url: "https://github.com/jverkoey/slipstream.git", branch: "main"),
    .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
  ],
  targets: [
    .executableTarget(name: "analytics", dependencies: [
      "AirtableAPI",
      "PostHogAPI",
    ]),

    .executableTarget(name: "modellist", dependencies: [
      "AirtableAPI",
      "DotEnvAPI",
    ]),

    .target(name: "AirtableAPI"),

    .target(name: "DotEnvAPI"),

    .target(name: "PostHogAPI"),

    .executableTarget(name: "gensite", dependencies: [
      "AirtableAPI",
      "DotEnvAPI",
      .product(name: "Slipstream", package: "slipstream"),
      "VehicleSupport",
      "VehicleSupportMatrix",
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

    .executableTarget(name: "supportmatrix-cli", dependencies: [
      "AirtableAPI",
      "DotEnvAPI",
      "SupportMatrix",
      "VehicleSupportMatrix"
    ]),

    .target(name: "SupportMatrix", dependencies: [
      .product(name: "Yams", package: "Yams"),
    ]),

    .target(name: "VehicleSupportMatrix", dependencies: [
      "AirtableAPI",
      "SupportMatrix",
    ]),

    .target(name: "VehicleSupport", resources: [
      .process("supportmatrix.json")
    ])
  ]
)
