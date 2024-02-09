// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SemVer",
    products: [
        .library(
            name: "SemVer",
            targets: ["SemVer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SemVer",
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SemVerTests",
            dependencies: ["SemVer"]
        ),
    ]
)
