//
//  RecurrenceRule+CalendarRecurrenceRule.swift
//  swift-recurrence
//
//  Created by David Monagle on 7/9/2025.
//

import Foundation


@available(macOS 15, iOS 18, *)
extension RecurrenceRule {
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
                weekdays: weekly.weekDays.map { .every($0) }
            )
        case .monthly(let monthly):
            return monthly.days.calendarRecurrenceRule(
                calendar: calendar,
                frequency: .monthly,
                interval: self.interval
            )
        case .annually(let annually):
            var rule = annually.days.calendarRecurrenceRule(
                calendar: calendar,
                frequency: .yearly,
                interval: self.interval
            )
            rule.months = annually.months.map { Calendar.RecurrenceRule.Month($0.rawValue) }
            return rule
        }
    }
}

@available(macOS 15, iOS 18, *)
extension RecurrenceRule {
    /// Generate recurrence dates using Apple's `Calendar.RecurrenceRule` engine,
    /// respecting this rule's `end` condition.
    ///
    /// - Parameters:
    ///   - start: The anchor date for the recurrence (defaults to the rule's `start`).
    ///   - range: The date range to search within.
    ///   - calendar: The calendar to use (defaults to `.current`).
    /// - Returns: An array of matching dates.
    public func recurrences(of start: Date? = nil, in range: Range<Date>, calendar: Calendar = .current) -> [Date] {
        let anchor = start ?? self.start
        let calRule = calendarRecurrenceRule(calendar)
        let sequence = calRule.recurrences(of: anchor, in: range)
        switch end {
        case .never:
            return Array(sequence)
        case .date(let endDate):
            return Array(sequence.prefix(while: { $0 <= endDate }))
        case .occurrences(let count):
            return Array(sequence.prefix(count))
        }
    }
}

@available(macOS 15, iOS 18, *)
extension RecurrenceRule.MonthDaysSelection {
    func calendarRecurrenceRule(calendar: Calendar, frequency: Calendar.RecurrenceRule.Frequency, interval: Int) -> Calendar.RecurrenceRule {
        switch self {
        case .every(let daysOfMonth):
            return .init(
                calendar: calendar,
                frequency: frequency,
                interval: interval,
                daysOfTheMonth: Array(daysOfMonth)
            )
        case .onThe(let ordinal, let weekDays):
            return .init(
                calendar: calendar,
                frequency: frequency,
                interval: interval,
                weekdays: weekDays.map { .nth(ordinal.rawValue, $0) }
            )
        }
    }
}
