// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoneyFlowLens",
    platforms: [.macOS(.v14)],
    dependencies: [],
    targets: [
        .target(
            name: "SankeyCore",
            path: "ThirdParty/SankeyCore"
        ),
        .executableTarget(
            name: "MoneyFlowLens",
            dependencies: [
                .product(name: "SankeyCore", package: "SankeyCore")
            ]
        ),
        .testTarget(
            name: "MoneyFlowLensTests",
            dependencies: ["MoneyFlowLens"]
        )
    ]
)
