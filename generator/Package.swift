// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "sidecar.clutch.engineering",
  platforms: [
    .macOS(.v15)
  ],
  dependencies: [
    .package(name: "slipstream", path: "../third_party/slipstream"),
    .package(name: "Yams", path: "../third_party/Yams"),
    .package(name: "swift-argument-parser", path: "../third_party/swift-argument-parser"),
  ],
  targets: [
    .executableTarget(name: "analytics", dependencies: [
      "AirtableAPI",
      "DotEnvAPI",
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
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
      .product(name: "Yams", package: "Yams"),
      "VehicleSupport",
      "VehicleSupportMatrix",
    ], resources: [
      .process("export-carplay-distance-traveled-by-model-yesterday.csv"),
      .process("export-carplay-distance-traveled-by-model.csv"),
      .process("export-carplay-drivers-by-model.csv"),
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

    .target(name: "VehicleSupport")
  ]
)
