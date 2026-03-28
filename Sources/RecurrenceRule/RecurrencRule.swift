//
//  RecurrencRule.swift
//  swift-recurrence
//
//  Created by David Monagle on 26/8/2025.
//

import RecurrenceCore
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
        public var weekDays: Set<RecurrenceDayOfWeek>

        public init(weekDays: Set<RecurrenceDayOfWeek>) { self.weekDays = weekDays }
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
        case onThe(ordinal: RecurrenceOrdinal, weekDays: Set<RecurrenceDayOfWeek>)
    }
}

extension RecurrenceRule {
    @available(macOS 15, *)
    public func calendarRecurrenceRule(_ calendar: Calendar) -> Calendar.RecurrenceRule {
        switch frequency {
        case .daily:
            return .init(
                calendar: calendar,
                frequency: .daily,
                interval: self.interval
            )
        case .weekly(let weekly):
            return .init(
                calendar: calendar,
                frequency: .weekly,
                interval: self.interval,
                weekdays: weekly.weekDays.map { .every($0.locale) }
            )
        case .monthly(let monthly):
            return .init(
                calendar: calendar,
                frequency: .monthly,
                interval: self.interval,
                daysOfTheMonth: monthly.days
            )
        case .annually(let annually):
        }
    }
}
