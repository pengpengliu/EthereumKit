// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EthereumKit",
    platforms: [
        .iOS(.v15), .macOS(.v12), .tvOS(.v15)
    ],
    products: [
        .library(
            name: "EthereumKit",
            targets: ["EthereumKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pengpengliu/Crypto101", from: "0.4.0"),
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
