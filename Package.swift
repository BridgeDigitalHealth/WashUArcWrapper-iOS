// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WashUArcWrapper-iOS",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WashUArcWrapper-iOS",
            targets: ["WashUArcWrapper-iOS"]),
    ],
    dependencies: [
        
        // Dependencies required to support *this* assessment wrapper
        .package(url: "https://github.com/CTRLab-WashU/ArcAssessmentsiOS.git",
                 from: "2.2.0"),
        
        // Dependencies required to connect to Bridge/Synapse
        .package(url: "https://github.com/Sage-Bionetworks/BridgeClientKMM.git",
                 from: "0.18.0"),
        .package(url: "https://github.com/Sage-Bionetworks/JsonModel-Swift.git",
                 from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WashUArcWrapper-iOS",
            dependencies: [
                .product(name: "Arc", package: "ArcAssessmentsiOS"),
                .product(name: "JsonModel", package: "JsonModel-Swift"),
                .product(name: "BridgeClient", package: "BridgeClientKMM"),
            ]
        ),
        .testTarget(
            name: "WashUArcWrapper-iOSTests",
            dependencies: ["WashUArcWrapper-iOS"]),
    ]
)
