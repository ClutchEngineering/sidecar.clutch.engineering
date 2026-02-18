// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftSoup",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "SwiftSoup", targets: ["SwiftSoup"])
    ],
    dependencies: [
        .package(name: "LRUCache", path: "../LRUCache"),
        .package(name: "swift-atomics", path: "../swift-atomics"),
    ],
    targets: [
        .target(
            name: "SwiftSoup",
            dependencies: [
                .product(name: "LRUCache", package: "LRUCache"),
                .product(name: "Atomics", package: "swift-atomics")
            ],
            path: "Sources"),
        .testTarget(
            name: "SwiftSoupTests", 
            dependencies: [
                "SwiftSoup",
                .product(name: "Atomics", package: "swift-atomics")
            ])
    ]
)
