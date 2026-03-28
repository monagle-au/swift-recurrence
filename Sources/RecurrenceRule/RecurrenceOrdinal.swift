import Foundation

/// Represents the ordinal position of a weekday within a month.
///
/// Used with ``RecurrenceRule/MonthDaysSelection/onThe(ordinal:weekDays:)`` to express
/// patterns such as "the last Friday" or "the second Monday" of a month.
///
/// Positive raw values (1–5) count from the start of the month; negative values count from the end:
/// - `.secondLast` has raw value `-2` (second-to-last occurrence)
/// - `.last` has raw value `-1` (last occurrence)
public enum RecurrenceMonthlyOrdinal : Int, Codable, Sendable, CaseIterable {
    /// The first occurrence of the weekday in the month.
    case first = 1
    /// The second occurrence of the weekday in the month.
    case second
    /// The third occurrence of the weekday in the month.
    case third
    /// The fourth occurrence of the weekday in the month.
    case fourth
    /// The fifth occurrence of the weekday in the month.
    case fifth
    /// The second-to-last occurrence of the weekday in the month (raw value `-2`).
    case secondLast = -2
    /// The last occurrence of the weekday in the month (raw value `-1`).
    case last = -1
}
