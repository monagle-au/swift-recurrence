//
//  RecurrencRule.swift
//  swift-recurrence
//
//  Created by David Monagle on 26/8/2025.
//


import Foundation

public struct RecurrenceRule: Sendable, Codable {
    public var interval: Int
    public var frequency: Frequency
    public var start: Date
    public var end: End

    public init(interval: Int, frequency: RecurrenceRule.Frequency, start: Date, end: RecurrenceRule.End) {
        self.interval = interval
        self.frequency = frequency
        self.start = start
        self.end = end
    }
}

extension RecurrenceRule {
    public enum End : Sendable, Codable, Equatable {
        case date(Date)
        case occurrences(Int)
        case never
    }

    public enum Frequency: Sendable, Codable {
        case daily(Daily)
        case weekly(Weekly)
        case monthly(Monthly)
        case annually(Annually)
    }

    public struct Daily : Sendable, Codable {
        public init() {}
    }

    public struct Weekly : Sendable, Codable {
        public var weekDays: Set<Locale.Weekday>

        public init(weekDays: Set<Locale.Weekday>) { self.weekDays = weekDays }
    }

    public struct Monthly: Sendable, Codable {
        public var days: MonthDaysSelection

        public init(days: RecurrenceRule.MonthDaysSelection) {
            self.days = days
        }
    }

    public struct Annually : Sendable, Codable {
        public var months: Set<RecurrenceMonth>
        public var days: MonthDaysSelection

        public init(months: Set<RecurrenceMonth>, days: RecurrenceRule.MonthDaysSelection) {
            self.months = months
            self.days = days
        }
    }

    public enum MonthDaysSelection : Sendable, Codable {
        case every(daysOfMonth: Set<Int>)
        case onThe(ordinal: RecurrenceMonthlyOrdinal, weekDays: Set<Locale.Weekday>)
    }
}

// MARK: - Validation

extension RecurrenceRule {
    public enum ValidationError: Error, Sendable {
        case intervalNotPositive(Int)
        case weekdaySelectionEmpty
        case daysOfMonthSelectionEmpty
        case monthSelectionEmpty
    }

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
    static func daily(interval: Int = 1, start: Date = .now, end: End = .never) -> Self {
        .init(interval: interval, frequency: .daily(.init()), start: start, end: end)
    }
}
