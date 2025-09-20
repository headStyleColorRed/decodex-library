// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "decodex-library",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DecodexCore",
            targets: ["DecodexCore"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DecodexCore",
            dependencies: [
            ],
            path: "Sources/DecodexCore"
        )
    ]
)
