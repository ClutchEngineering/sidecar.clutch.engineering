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
    .executableTarget(name: "gensite", dependencies: [
      .product(name: "Slipstream", package: "slipstream"),
      "VehicleSupport",
    ]),

    .target(name: "VehicleSupport", resources: [
      .process("supportmatrix.json")
    ])
  ]
)
