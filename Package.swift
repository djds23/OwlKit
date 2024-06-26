// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OwlKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "OwlKitCLI", targets: [
            "OwlKitCLI",
            "OwlKit",
        ]),
        .library(
            name: "OwlKit",
            targets: ["OwlKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "OwlKitCLI",
            dependencies: [
                .target(name: "OwlKit")
            ]
        ),
        .target(
            name: "OwlKit",
            swiftSettings: [
              .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "OwlKitTests",
            dependencies: [
                .target(name: "OwlKit")
            ]
        ),
    ]
)
