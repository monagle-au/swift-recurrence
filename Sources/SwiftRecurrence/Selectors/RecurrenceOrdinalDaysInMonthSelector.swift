//
//  RecurrenceOrdinalDaysInMonthSelector.swift
//  Recurrence
//
//  Created by David Monagle on 19/7/19.
//

import Foundation

public class RecurrenceOrdinalDaysInMonthSelector: Recurrable, Codable {
    public var intervalUnit : Interval.Unit { return .day }
    
    var ordinal: RecurrenceMonthlyOrdinal
    var days : Set<RecurrenceDayOfWeek> = []
    
    public init(ordinal: RecurrenceMonthlyOrdinal, days: Set<RecurrenceDayOfWeek> = []) {
        self.ordinal = ordinal
        self.days = days
    }
    
    internal func matchingDayOfMonth(for date: Date, options: RecurrenceOptions) -> Int? {
        guard let daysOfMonth = ordinal.daysOfMonth(for: date, options: options) else { return nil }
        
        // Calculate the first weekday in the daysOfMonth
        var componentsForFirstDayInRange = options.calendar.dateComponents([.month, .year], from: date)
        componentsForFirstDayInRange.day = daysOfMonth.first
        let firstDateInRange = options.calendar.date(from: componentsForFirstDayInRange)!
        var weekday = options.calendar.recurrenceDayOfWeek(for: firstDateInRange)
        
        // Create an array of weekdays that maps directly to the daysOfMonth
        let daysOfMonthRange = Array((daysOfMonth.first ... daysOfMonth.last))
        let enumeratedWeekdayRange = daysOfMonthRange.map { (_) -> RecurrenceDayOfWeek in
            let result = weekday
            weekday = weekday.next()
            return result
        }.enumerated()

        switch ordinal {
        case .last:
            if self.days.isEmpty { return daysOfMonthRange.last }
            for (index, day) in enumeratedWeekdayRange.reversed() {
                if self.days.contains(day) { return daysOfMonthRange[index] }
            }
        default:
            if self.days.isEmpty { return daysOfMonthRange.first }
            for (index, day) in enumeratedWeekdayRange {
                if self.days.contains(day) { return daysOfMonthRange[index] }
            }
            break
        }
        
        return nil
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        guard let matchingDay = self.matchingDayOfMonth(for: date, options: options) else { return false }
        let currentDay = options.calendar.component(.day, from: date)
        return currentDay == matchingDay
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        guard let matchingDay = self.matchingDayOfMonth(for: date, options: options) else { return nil }
        var components = options.calendar.dateComponents([.month, .year], from: date)
        components.day = matchingDay
        return options.calendar.date(from: components)
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        return first(for: date, options: options)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        return self.date(relativeTo: date, using: <, options: options)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        return self.date(relativeTo: date, using: >, options: options)
    }
    
    internal func date(relativeTo date: Date, using compare: (Int, Int) -> Bool, options: RecurrenceOptions) -> Date? {
        guard let matchingDay = self.matchingDayOfMonth(for: date, options: options) else { return nil }
        var components = options.calendar.dateComponents([.month, .year, .day], from: date)
        if compare(components.day!, matchingDay) {
            components.day = matchingDay
            return options.calendar.date(from: components)
        }
        return nil
    }
}
