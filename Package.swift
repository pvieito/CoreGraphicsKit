// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CoreGraphicsKit",
    products: [
        .library(
            name: "CoreGraphicsKit",
            targets: ["CoreGraphicsKit"]
        )
    ],
    dependencies: [
        .package(path: "../FoundationKit")
    ],
    targets: [
        .target(
            name: "CoreGraphicsKit",
            dependencies: ["FoundationKit"],
            path: "CoreGraphicsKit"
        )
    ]
)
