// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "slipstream",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
  ],
  products: [
    .library(name: "Slipstream", targets: ["Slipstream"]),
  ],
  dependencies: [
    .package(name: "swift-markdown", path: "../swift-markdown"),
    .package(name: "SwiftSoup", path: "../SwiftSoup"),
  ],
  targets: [
    .target(name: "Slipstream", dependencies: [
      .product(name: "Markdown", package: "swift-markdown"),
      "SwiftSoup",
      "TypeIntrospection",
    ]),
    .testTarget(name: "SlipstreamTests", dependencies: [
      "Slipstream",
    ]),

    .target(name: "TypeIntrospection"),
    .testTarget(name: "TypeIntrospectionTests", dependencies: [
      "TypeIntrospection",
    ]),
  ]
)
