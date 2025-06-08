// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MoneyFlowLens",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "MoneyFlowLens", targets: ["MoneyFlowLens"])
    ],
    targets: [
        .target(
            name: "SankeyCore",
            path: "ThirdParty/SankeyCore"
        ),
        .executableTarget(
            name: "MoneyFlowLens",
            dependencies: ["SankeyCore"],
            path: "Sources/MoneyFlowLens"
        ),
        .testTarget(
            name: "MoneyFlowLensTests",
            dependencies: ["MoneyFlowLens"]
        )
    ]
)
