# ``RecurrenceRule``

A Swift library for modelling recurring date patterns as user intent.

## Overview

RecurrenceRule captures *what a user means* when they say "every second Monday" or "the last Friday of each month" — not the raw `Calendar.RecurrenceRule` parameters those patterns eventually produce. This separation keeps the model simple, UI-friendly, and serialisation-stable.

The package ships three modules:

- **RecurrenceRule** — the core model. Use this in any target that needs to store or reason about recurrence rules without a UI dependency.
- **RecurrenceUI** — SwiftUI components built on top of `RecurrenceRule`. Drop in ``RecurrenceRuleView`` to give users a complete recurrence editor.
- **RecurrenceProtobuf** — bidirectional protobuf serialisation for `RecurrenceRule`. Use this when you need a compact, version-stable wire format (e.g. for an API or local database).

## Topics

### Core Types
- ``RecurrenceRule``
- ``RecurrenceRule/Frequency``
- ``RecurrenceRule/End``
- ``RecurrenceRule/MonthDaysSelection``
- ``RecurrenceMonth``
- ``RecurrenceMonthlyOrdinal``

### Generating Dates
- ``RecurrenceRule/calendarRecurrenceRule(_:)``
- ``RecurrenceRule/recurrences(of:in:calendar:)``

### Validation
- ``RecurrenceRule/validate()``
- ``RecurrenceRule/ValidationError``
