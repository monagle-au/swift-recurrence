//
//  RecurrencRule.swift
//  swift-recurrence
//
//  Created by David Monagle on 26/8/2025.
//


import Foundation

/// A user-intent model for a recurring date pattern.
///
/// `RecurrenceRule` captures *what a user means* when they say "every second Monday" or
/// "the last Friday of each month" — not the raw `Calendar.RecurrenceRule` parameters that
/// pattern eventually produces. This separation keeps the model simple, UI-friendly, and
/// serialisation-stable.
///
/// The struct is `Codable` and `Sendable`. Use ``validate()`` or ``isValid`` to check whether
/// the current field values form a coherent rule before converting to a calendar rule.
public struct RecurrenceRule: Sendable, Codable {
    /// A multiplier applied to the frequency unit.
    ///
    /// For example, an interval of `2` with a weekly frequency means "every 2 weeks".
    /// Must be greater than zero; see ``ValidationError/intervalNotPositive(_:)``.
    public var interval: Int

    /// The type and configuration of the recurrence (daily, weekly, monthly, or annually).
    public var frequency: Frequency

    /// The anchor date from which recurrences are generated.
    public var start: Date

    /// The termination condition for the recurrence sequence.
    public var end: End

    /// Creates a new `RecurrenceRule`.
    ///
    /// - Parameters:
    ///   - interval: Multiplier for the frequency unit. Must be greater than zero.
    ///   - frequency: Type and configuration of the recurrence.
    ///   - start: Anchor date from which recurrences are generated.
    ///   - end: Termination condition for the recurrence sequence.
    public init(interval: Int, frequency: RecurrenceRule.Frequency, start: Date, end: RecurrenceRule.End) {
        self.interval = interval
        self.frequency = frequency
        self.start = start
        self.end = end
    }
}

extension RecurrenceRule {
    /// The termination condition for a ``RecurrenceRule``.
    public enum End : Sendable, Codable, Equatable {
        /// Recurrences end on or before the given date.
        case date(Date)
        /// Recurrences end after the given number of occurrences.
        case occurrences(Int)
        /// Recurrences continue indefinitely.
        case never
    }

    /// The type and configuration of a recurrence.
    public enum Frequency: Sendable, Codable {
        /// Repeats on a daily basis.
        case daily(Daily)
        /// Repeats on specific days of the week.
        case weekly(Weekly)
        /// Repeats on specific days of the month.
        case monthly(Monthly)
        /// Repeats on specific months and days each year.
        case annually(Annually)
    }

    /// Configuration for a daily recurrence.
    ///
    /// No extra parameters are needed — the cadence is controlled entirely by
    /// ``RecurrenceRule/interval``.
    public struct Daily : Sendable, Codable {
        public init() {}
    }

    /// Configuration for a weekly recurrence.
    public struct Weekly : Sendable, Codable {
        /// The days of the week on which the event recurs.
        public var weekDays: Set<Locale.Weekday>

        /// Creates a weekly recurrence configuration.
        /// - Parameter weekDays: Days of the week on which the event recurs. Must not be empty.
        public init(weekDays: Set<Locale.Weekday>) { self.weekDays = weekDays }
    }

    /// Configuration for a monthly recurrence.
    public struct Monthly: Sendable, Codable {
        /// Specifies which day(s) of the month the event recurs on.
        public var days: MonthDaysSelection

        /// Creates a monthly recurrence configuration.
        /// - Parameter days: Selection strategy for the day(s) within each month.
        public init(days: RecurrenceRule.MonthDaysSelection) {
            self.days = days
        }
    }

    /// Configuration for an annual recurrence.
    public struct Annually : Sendable, Codable {
        /// The months in which the event recurs.
        public var months: Set<RecurrenceMonth>
        /// Specifies which day(s) within each selected month the event recurs on.
        public var days: MonthDaysSelection

        /// Creates an annual recurrence configuration.
        /// - Parameters:
        ///   - months: Months in which the event recurs. Must not be empty.
        ///   - days: Selection strategy for the day(s) within each selected month.
        public init(months: Set<RecurrenceMonth>, days: RecurrenceRule.MonthDaysSelection) {
            self.months = months
            self.days = days
        }
    }

    /// Specifies how the day(s) within a month are selected for a recurrence.
    public enum MonthDaysSelection : Sendable, Codable {
        /// Recurs on specific numbered days of the month (1–31).
        ///
        /// For example, `.every(daysOfMonth: [1, 15])` means "the 1st and 15th".
        case every(daysOfMonth: Set<Int>)
        /// Recurs on an ordinal weekday pattern within the month.
        ///
        /// For example, `.onThe(ordinal: .last, weekDays: [.friday])` means "the last Friday".
        case onThe(ordinal: RecurrenceMonthlyOrdinal, weekDays: Set<Locale.Weekday>)
    }
}

// MARK: - Validation

extension RecurrenceRule {
    /// Errors that can be thrown when a ``RecurrenceRule`` fails validation.
    public enum ValidationError: Error, Sendable {
        /// The ``RecurrenceRule/interval`` is not a positive integer.
        case intervalNotPositive(Int)
        /// No weekdays have been selected for a weekly (or "on the" monthly/annual) recurrence.
        case weekdaySelectionEmpty
        /// No days of the month have been selected for an `.every` monthly/annual recurrence.
        case daysOfMonthSelectionEmpty
        /// No months have been selected for an annual recurrence.
        case monthSelectionEmpty
    }

    /// Validates the rule and throws if any field is in an inconsistent state.
    ///
    /// - Throws: ``ValidationError`` describing the first inconsistency found.
    public func validate() throws {
        guard interval > 0 else { throw ValidationError.intervalNotPositive(interval) }

        switch frequency {
        case .daily:
            break
        case .weekly(let weekly):
            if weekly.weekDays.isEmpty { throw ValidationError.weekdaySelectionEmpty }
        case .monthly(let monthly):
            try monthly.days.validate()
        case .annually(let annually):
            if annually.months.isEmpty { throw ValidationError.monthSelectionEmpty }
            try annually.days.validate()
        }
    }

    /// Returns `true` when the rule passes all validation checks, `false` otherwise.
    public var isValid: Bool {
        (try? validate()) != nil
    }
}

extension RecurrenceRule.MonthDaysSelection {
    func validate() throws {
        switch self {
        case .every(let daysOfMonth):
            if daysOfMonth.isEmpty { throw RecurrenceRule.ValidationError.daysOfMonthSelectionEmpty }
        case .onThe(_, let weekDays):
            if weekDays.isEmpty { throw RecurrenceRule.ValidationError.weekdaySelectionEmpty }
        }
    }
}

// MARK: - Static Functions

extension RecurrenceRule {
    /// Convenience factory that creates a simple daily recurrence.
    ///
    /// - Parameters:
    ///   - interval: How many days between each recurrence (default `1`).
    ///   - start: Anchor date (default `.now`).
    ///   - end: Termination condition (default `.never`).
    /// - Returns: A new `RecurrenceRule` with daily frequency.
    public static func daily(interval: Int = 1, start: Date = .now, end: End = .never) -> Self {
        .init(interval: interval, frequency: .daily(.init()), start: start, end: end)
    }
}
