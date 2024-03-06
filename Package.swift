// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-recurrence",
    products: [
        .library(
            name: "SwiftRecurrence",
            targets: ["SwiftRecurrence"]),
    ],
    targets: [
        .target(
            name: "SwiftRecurrence"),
        .testTarget(
            name: "SwiftRecurrenceTests",
            dependencies: ["SwiftRecurrence"]),
    ]
)
