// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LarisOS",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LarisOS",
            targets: ["LarisOS"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LarisOS",
            path: "LarisOS"
        ),
        .testTarget(
            name: "LarisOSTests",
            dependencies: ["LarisOS"],
            path: "Tests"
        ),
    ]
)
