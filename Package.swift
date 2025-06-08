// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoneyFlowLens",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/maxhumber/Sankey", from: "0.2.1")
    ],
    targets: [
        .executableTarget(
            name: "MoneyFlowLens",
            dependencies: [
                .product(name: "Sankey", package: "Sankey")
            ]
        ),
        .testTarget(
            name: "MoneyFlowLensTests",
            dependencies: ["MoneyFlowLens"]
        )
    ]
)
