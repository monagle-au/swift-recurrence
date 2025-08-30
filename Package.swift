// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-recurrence",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftRecurrence",
            targets: ["RecurrenceCore", "RecurrenceStack"]),
    ],
    targets: [
        .target(
            name: "RecurrenceCore"
        ),
        .target(
            name: "RecurrenceRule",
            dependencies: [
                "RecurrenceCore"
            ]
        ),
        .target(
            name: "RecurrenceStack",
            dependencies: [
                "RecurrenceCore"
            ]
        ),
        .testTarget(
            name: "RecurrenceStackTests",
            dependencies: ["RecurrenceStack"]
        ),
    ]
)
