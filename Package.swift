// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBVapor",
    platforms: [
       .macOS(.v11)
    ],
    products: [
        .library(
            name: "SBVapor",
            targets: ["SBVapor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "SBVapor",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .testTarget(
            name: "SBVaporTests",
            dependencies: ["SBVapor"]
        ),
    ]
)
