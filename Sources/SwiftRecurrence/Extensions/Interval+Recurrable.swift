//
//  Interval+Recurrable.swift
//  Recurrence
//
//  Created by David Monagle on 1/4/19.
//

import Foundation

extension Interval : Recurrable {
    public var intervalUnit : Unit { return unit }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        guard let startOfInterval = first(for: date, options: options) else { return false }

        func compareComponents(_ components: Set<Calendar.Component>) -> Bool {
            options.calendar.compare(date: startOfInterval, and: date, toGranularity: components)
        }

        return switch self.unit {
        case .day:
            compareComponents([.day, .month, .year])
        case .week:
            options.calendar.datesAreWithinSameWeek(startOfInterval, date)
        case .month:
            compareComponents([.month, .year])
        case .year:
            compareComponents([.year])
        }
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        guard number > 0, options.canContain(date: date) else { return nil }
        
        switch self.unit {
        case .day:
            let startOfDay = options.calendar.startOfDay(for: date)
            let start = options.calendar.startOfDay(for: options.generateStartDate())
            let difference = options.calendar.dateComponents([.day], from: start, to: startOfDay).day!
            let offset = (difference % self.number) * -1
            return options.calendar.date(byAdding: offset.recurringDays, to: startOfDay)
        case .week:
            let startOfWeek = options.calendar.startOfWeek(for: date)
            let start = options.calendar.startOfWeek(for: options.generateStartDate())
            let difference = options.calendar.dateComponents([.day], from: start, to: startOfWeek).day! / 7
            let offset = (difference % self.number) * -1
            return options.calendar.date(byAdding: offset.recurringWeeks, to: startOfWeek)
        case .month:
            let startOfMonth = options.calendar.startOfMonth(for: date)
            let start = options.calendar.startOfMonth(for: options.generateStartDate())
            let difference = options.calendar.dateComponents([.month], from: start, to: startOfMonth).month!
            let offset = (difference % self.number) * -1
            return options.calendar.date(byAdding: offset.recurringMonths, to: startOfMonth)
        case .year:
            let startOfYear = options.calendar.startOfYear(for: date)
            let start = options.calendar.startOfYear(for: options.generateStartDate())
            let difference = options.calendar.dateComponents([.year], from: start, to: startOfYear).year!
            let offset = (difference % self.number) * -1
            return options.calendar.date(byAdding: offset.recurringYears, to: startOfYear)
        }
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        guard let start = first(for: date, options: options) else { return nil }
        var components = DateComponents()
        switch self.unit {
        case .day:
            return start
        case .week:
            components.day = 6
        case .month:
            components.month = 1
            components.day = -1
        case .year:
            components.year = 1
            components.day = -1
        }
        return options.calendar.date(byAdding: components, to: start)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        if matches(date: date, options: options) {
            let previous = options.calendar.date(bySubtracting: self, from: date)!
            return first(for: previous, options: options)
        }
        return first(for: date, options: options)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        let next = options.calendar.date(byAdding: self, to: date)!
        return first(for: next, options: options)
    }
}
