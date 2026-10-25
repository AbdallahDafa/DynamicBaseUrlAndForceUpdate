// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dynamic_base_url_and_force_update",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "dynamic-base-url-and-force-update", targets: ["dynamic_base_url_and_force_update"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "dynamic_base_url_and_force_update",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, add a PrivacyInfo.xcprivacy file next to the Swift sources to describe
                // your plugin's privacy impact, and then uncomment this line. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
