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
            targets: ["RecurrenceCore", "RecurrenceRule", "RecurrenceStack"]
        ),
        .library(
            name: "SwiftRecurrenceUI",
            targets: ["RecurrenceUI"]
        ),
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
        .target(
            name: "RecurrenceUI",
            dependencies: [
                "RecurrenceCore",
                "RecurrenceRule"
            ]
        ),
        .testTarget(
            name: "RecurrenceCoreTests",
            dependencies: ["RecurrenceCore"]
        ),
        .testTarget(
            name: "RecurrenceRuleTests",
            dependencies: ["RecurrenceRule"]
        ),
        .testTarget(
            name: "RecurrenceStackTests",
            dependencies: ["RecurrenceStack"]
        ),
    ]
)
