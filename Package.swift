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
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "DecodexCore",
            dependencies: [
                .product(name: "WebSocketKit", package: "websocket-kit")
            ],
            path: "Sources/DecodexCore"
        )
    ]
)
