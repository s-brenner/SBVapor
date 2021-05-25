// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBVapor",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SBVapor",
            targets: ["SBVapor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "SBVapor", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Vapor", package: "vapor"),
        ]),
        .testTarget(name: "SBVaporTests", dependencies: [
            .target(name: "SBVapor"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
    ]
)
