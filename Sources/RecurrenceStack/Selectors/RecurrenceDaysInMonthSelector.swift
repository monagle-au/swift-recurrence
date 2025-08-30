//
//  RecurrenceDaysInMonthSelector.swift
//  Recurrence
//
//  Created by David Monagle on 1/4/19.
//

import Foundation

public class RecurrenceDaysInMonthSelector : Recurrable, Codable {
    public var intervalUnit : Interval.Unit { return .day }
    
    var days : Set<Int> = []
    
    public init(days: Set<Int> = []) {
        self.days = days
    }
    
    private func dayOptions(for date: Date, options: RecurrenceOptions) -> Array<Int> {
        let daysInMonth = options.calendar.daysInMonth(of: date)
        return days.sorted().filter { $0 <= daysInMonth }
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        let currentDay = options.calendar.component(.day, from: date)
        return days.contains(currentDay)
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        guard let firstDay = dayOptions(for: date, options: options).first else { return nil }
        let difference = firstDay - options.calendar.component(.day, from: date)
        return options.calendar.date(byAdding: difference.recurringDays, to: date)
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        guard let lastDay = dayOptions(for: date, options: options).last else { return nil }
        let difference = lastDay - options.calendar.component(.day, from: date)
        return options.calendar.date(byAdding: difference.recurringDays, to: date)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        let currentDay = options.calendar.component(.day, from: date)
        guard let nextDay = dayOptions(for: date, options: options).first(where: { $0 > currentDay }) else { return nil}
        let difference = nextDay - currentDay
        return options.calendar.date(byAdding: DateComponents(day: difference), to: date)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        let currentDay = options.calendar.component(.day, from: date)
        guard let nextDay = dayOptions(for: date, options: options).last(where: { $0 < currentDay }) else { return nil}
        let difference = (currentDay - nextDay) * -1
        return options.calendar.date(byAdding: DateComponents(day: difference), to: date)
    }
}
