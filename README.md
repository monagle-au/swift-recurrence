# swift-recurrence

A Swift package for modelling recurring date patterns as user intent.

`swift-recurrence` captures *what a user means* when they say "every second Monday" or "the last Friday of each month" — not the raw `Calendar.RecurrenceRule` parameters those patterns eventually produce. This separation keeps the model simple, UI-friendly, and serialisation-stable.

---

## Modules

| Module | Target | When to use |
|--------|--------|-------------|
| **SwiftRecurrence** | `RecurrenceRule` | Core model only — no UI or serialisation dependencies. Use this in a shared framework, background service, or anywhere you need to store and reason about recurrence rules. |
| **SwiftRecurrenceUI** | `RecurrenceUI` | SwiftUI components that let users create and edit a `RecurrenceRule`. Depends on `RecurrenceRule`. |
| **SwiftRecurrenceProtobuf** | `RecurrenceProtobuf` | Bidirectional protobuf (v1) serialisation for `RecurrenceRule`. Use this for compact, version-stable on-wire or on-disk storage. Depends on `RecurrenceRule` and `swift-protobuf`. |

---

## Requirements

- **Swift** 6.0+
- **macOS** 15+
- **iOS** 18+

---

## Installation

Add the package via Swift Package Manager. In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/monagle-au/swift-recurrence.git", from: "2.0.0"),
],
```

Then add the products you need to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "SwiftRecurrence", package: "swift-recurrence"),
        .product(name: "SwiftRecurrenceUI", package: "swift-recurrence"),        // optional
        .product(name: "SwiftRecurrenceProtobuf", package: "swift-recurrence"), // optional
    ]
),
```

---

## Usage

### Creating a RecurrenceRule

```swift
import SwiftRecurrence

// Every 2 weeks on Monday and Wednesday, starting today, ending after 10 occurrences
let rule = RecurrenceRule(
    interval: 2,
    frequency: .weekly(.init(weekDays: [.monday, .wednesday])),
    start: .now,
    end: .occurrences(10)
)

// Validate before using
try rule.validate()

// Generate upcoming dates (requires macOS 15 / iOS 18)
let dates = rule.recurrences(in: Date.now ..< Calendar.current.date(byAdding: .year, value: 1, to: .now)!)
```

### Using RecurrenceRuleView in SwiftUI

```swift
import SwiftUI
import SwiftRecurrence
import SwiftRecurrenceUI

struct ContentView: View {
    @State private var rule = RecurrenceRule(
        interval: 1,
        frequency: .weekly(.init(weekDays: [.monday])),
        start: .now,
        end: .never
    )

    var body: some View {
        NavigationStack {
            RecurrenceRuleView($rule)
                .navigationTitle("Set Schedule")
        }
    }
}
```

### Protobuf round-trip

```swift
import SwiftRecurrence
import SwiftRecurrenceProtobuf

let rule = RecurrenceRule(
    interval: 1,
    frequency: .monthly(.init(days: .onThe(ordinal: .last, weekDays: [.friday]))),
    start: .now,
    end: .never
)

// Encode
let proto = RecurrenceProtoV1RecurrenceRule(rule)
let data = try proto.serializedData()

// Decode
let decoded = try RecurrenceRule(proto: .init(serializedBytes: data))
```

---

## Documentation

Full DocC documentation is available for the `RecurrenceRule` module. Build it locally with:

```
swift package generate-documentation --target RecurrenceRule
```

Or open the package in Xcode and choose **Product > Build Documentation**.
