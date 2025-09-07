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
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "DecodexCore",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/DecodexCore"
        ),
        .testTarget(
            name: "DecodexCoreTests",
            dependencies: ["DecodexCore"],
            path: "Tests/DecodexCoreTests"
        ),
    ]
)