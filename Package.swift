// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-recurrence",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SwiftRecurrence",
            targets: ["RecurrenceRule"]
        ),
        .library(
            name: "SwiftRecurrenceUI",
            type: .dynamic,
            targets: ["RecurrenceUI"]
        ),
    ],
    targets: [
        .target(
            name: "RecurrenceRule"
        ),
        .target(
            name: "RecurrenceUI",
            dependencies: [
                "RecurrenceRule"
            ]
        ),
        .testTarget(
            name: "RecurrenceRuleTests",
            dependencies: ["RecurrenceRule"]
        ),
    ]
)
