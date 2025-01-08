// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iProovAPIClient",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "iProovAPIClient",
            targets: ["iProovAPIClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "iProovAPIClient",
            dependencies: ["Alamofire"]
        ),
    ]
)
