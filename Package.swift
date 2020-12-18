// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EthereumKit",
    platforms: [
        .macOS(.v10_12),
    ],
    products: [
        .library(
            name: "EthereumKit",
            targets: ["EthereumKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pengpengliu/Crypto101.git", .upToNextMinor(from: "0.2.3")),
//        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.3.1")),
        // .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EthereumKit",
            dependencies: ["Crypto101"]),
        .testTarget(
            name: "EthereumKitTests",
            dependencies: ["EthereumKit"]),
    ]
)
