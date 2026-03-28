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
        .library(
            name: "SwiftRecurrenceProtobuf",
            targets: ["RecurrenceProtobuf"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.28.2"),
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
        .target(
            name: "RecurrenceProtobuf",
            dependencies: [
                "RecurrenceRule",
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            ]
        ),
        .testTarget(
            name: "RecurrenceRuleTests",
            dependencies: ["RecurrenceRule"]
        ),
        .testTarget(
            name: "RecurrenceProtobufTests",
            dependencies: ["RecurrenceProtobuf"]
        ),
    ]
)
