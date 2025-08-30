//
//  RecurrenceDaysInWeekSelector.swift
//  Recurrence
//
//  Created by David Monagle on 1/4/19.
//

import RecurrenceCore
import Foundation

public class RecurrenceDaysInWeekSelector : Recurrable, Codable {
    public var intervalUnit : Interval.Unit { return .week }
    var daysOfWeek : Set<RecurrenceDayOfWeek> = []
    
    public init(daysOfWeek: Set<RecurrenceDayOfWeek> = []) {
        self.daysOfWeek = daysOfWeek
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        return daysOfWeek.contains(RecurrenceDayOfWeek(from: date))
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        let firstDay = daysOfWeek.sorted().first?.rawValue ?? 1 // First day or Sunday if it's everyday
        let difference = firstDay - options.calendar.component(.weekday, from: date)
        return options.calendar.date(byAdding: difference.recurringDays, to: date)
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        let lastDay = daysOfWeek.sorted().last?.rawValue ?? 1 // Last day or Saturday if it's everyday
        let difference = lastDay - options.calendar.component(.weekday, from: date)
        return options.calendar.date(byAdding: difference.recurringDays, to: date)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        let currentDay = RecurrenceDayOfWeek(from: date)
        guard let nextDay = daysOfWeek.sorted().first(where: { $0 > currentDay }) else { return nil}
        let difference = nextDay.rawValue - currentDay.rawValue
        return options.calendar.date(byAdding: DateComponents(day: difference), to: date)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        let currentDay = RecurrenceDayOfWeek(from: date)
        guard let nextDay = daysOfWeek.sorted().last(where: { $0 < currentDay }) else { return nil}
        let difference = (currentDay.rawValue - nextDay.rawValue) * -1
        return options.calendar.date(byAdding: difference.recurringDays, to: date)
    }
}
