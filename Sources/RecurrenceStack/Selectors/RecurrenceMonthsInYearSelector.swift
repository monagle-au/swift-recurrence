//
//  RecurrenceMonthsInYearSelector.swift
//  Recurrence
//
//  Created by David Monagle on 1/4/19.
//

import RecurrenceCore
import Foundation

public class RecurrenceMonthsInYearSelector : Recurrable, Codable {
    public var intervalUnit : Interval.Unit { return .month }
    
    var months : Set<RecurrenceMonth> = []
    
    public init(months: Set<RecurrenceMonth> = []) {
        self.months = months
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        let currentMonth = RecurrenceMonth(from: date, calendar: options.calendar)
        return months.contains(currentMonth)
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        let month = months.sorted().first ?? .january
        var components = options.calendar.dateComponents([.year], from: date)
        components.month = month.rawValue
        return options.calendar.date(from: components)
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        let month = months.sorted().last ?? .december
        var components = options.calendar.dateComponents([.year], from: date)
        components.month = month.rawValue
        components.day = month.numberOfDays(year: options.calendar.component(.year, from: date), calendar: options.calendar)
        return options.calendar.date(from: components)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        let currentMonth = RecurrenceMonth(from: date)
        guard let nextMonth = months.sorted().first(where: { $0 > currentMonth }) else { return nil}
        var components = options.calendar.dateComponents([.year], from: date)
        components.month = nextMonth.rawValue
        return options.calendar.date(from: components)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        let currentMonth = RecurrenceMonth(from: date)
        guard let nextMonth = months.sorted().last(where: { $0 < currentMonth }) else { return nil}
        var components = options.calendar.dateComponents([.year], from: date)
        components.month = nextMonth.rawValue
        return options.calendar.date(from: components)
    }
}
