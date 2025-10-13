// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "decodex-library",
    platforms: [
        .macOS(.v14),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DecodexCore",
            targets: ["DecodexCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.1.0"))
    ],
    targets: [
        .target(
            name: "DecodexCore",
            dependencies: [
                .product(name: "ObjectMapper", package: "ObjectMapper")
            ],
            path: "Sources/DecodexCore"
        )
    ]
)
