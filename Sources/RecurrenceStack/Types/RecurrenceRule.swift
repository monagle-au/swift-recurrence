//
//  RecurrenceRule.swift
//  Recurrence
//
//  Created by David Monagle on 18/2/19.
//  Copyright © 2019 Monagle. All rights reserved.
//

import RecurrenceCore
import Foundation

public enum RecurrenceRule: Equatable {
    case daily(every: Int)
    case weekly(every: Int, days: Set<RecurrenceDayOfWeek>)
    case monthly(every: Int, days: Set<Int>)
    case monthlyOrdinal(every: Int, onThe: RecurrenceMonthlyOrdinal, Set<RecurrenceDayOfWeek>)
    case annually(every: Int, in: Set<RecurrenceMonth>, days: Set<Int>)
    case annuallyOrdinal(every: Int, in: Set<RecurrenceMonth>, onThe: RecurrenceMonthlyOrdinal, Set<RecurrenceDayOfWeek>)
}

public enum RecurrenceError : Error {
    case daySelectionCannotBeEmpty
    case weekdaySelectionCannotBeEmpty
    case daysOfMonthSelectionCannotBeEmpty
    case monthsSelectionCannotBeEmpty
    case monthDayOutsideOfRange(Int)
    case intervalNotPositive(Int)
    case dateError(Date, String)
    case invalidNumericForWeekday(Int)
    case invalidNumericForMonth(Int)
    case unimplemented
}

public extension RecurrenceRule {
    func validate() throws {
        switch self {
        case .daily:
            break
        case .weekly(_, let daysOfWeek):
            if daysOfWeek.isEmpty { throw RecurrenceError.weekdaySelectionCannotBeEmpty }
        case .monthly(_, let days):
            if days.isEmpty { throw RecurrenceError.daysOfMonthSelectionCannotBeEmpty }
        case .monthlyOrdinal(_, _, let days):
            if days.isEmpty { throw RecurrenceError.weekdaySelectionCannotBeEmpty }
        case .annually(_, let months, let days):
            if months.isEmpty { throw RecurrenceError.monthsSelectionCannotBeEmpty }
            if days.isEmpty { throw RecurrenceError.weekdaySelectionCannotBeEmpty }
        case .annuallyOrdinal(_, let months, _, let days):
            if months.isEmpty { throw RecurrenceError.monthsSelectionCannotBeEmpty }
            if days.isEmpty { throw RecurrenceError.weekdaySelectionCannotBeEmpty }
        }
    }
    
    var isValid: Bool {
        do {
            try validate()
            return true
        }
        catch {
            return false
        }
    }
}

extension RecurrenceRule : Recurrable {
    public var intervalUnit: Interval.Unit {
        return stack.intervalUnit
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        guard isValid else { return false }
        return stack.matches(date: date, options: options)
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        guard isValid else { return nil }
        return stack.first(for: date, options: options)
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        guard isValid else { return nil }
        return stack.last(for: date, options: options)
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        guard isValid else { return nil }
        return stack.date(before: date, options: options)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        guard isValid else { return nil }
        return stack.date(after: date, options: options)
    }
    
    var stack : RecurrenceStack {
        switch self {
        case .daily(let every):
            .dailyStack(every: every)
        case .weekly(let every, let days):
            .weeklyStack(every: every, days: days)
        case .monthly(let every, let days):
            .monthlyStack(every: every, days: days)
        case .monthlyOrdinal(let every, let ordinal, let daysOfWeek):
                .monthlyOrdinalStack(every: every, onThe: ordinal, daysOfWeek)
        case .annually(let every, let months, let days):
            .annualStack(every: every, in: months, days: days)
        case .annuallyOrdinal(let every, let months, let ordinal, let daysOfWeek):
            .annuallyOrdinalStack(every: every, in: months, onThe: ordinal, daysOfWeek)
        }
    }
}

// MARK: - Periods

public extension RecurrenceRule {
    func firstDayOfPeriod(containing date: Date, options: RecurrenceOptions? = nil) -> Date? {
        let options = options ?? .init()

        if let startDate = options.startDate, startDate > date { return nil }
        if let endDate = options.endDate, endDate < date { return nil }

        if let previousDate = self.date(before: date, options: options) {
            if let startDate = options.startDate, previousDate < startDate {
                return startDate
            }
            return Calendar.current.date(byAdding: 1.recurringDays, to: previousDate)
        }
        
        return options.startDate
    }

    func lastDayOfPeriod(containing date: Date, options: RecurrenceOptions? = nil) -> Date? {
        let options = options ?? .init()

        if let startDate = options.startDate, startDate > date { return nil }
        if let endDate = options.endDate, endDate < date { return nil }

        if self.matches(date: date, options: options) { return date }
        if let lastDate = self.date(after: date, options: options) {
            if let endDate = options.endDate, endDate < lastDate { return endDate }
            return lastDate
        }
        return options.endDate
    }
    
    func daysInPeriod(containing date: Date, options: RecurrenceOptions? = nil) -> Int {
        let options = options ?? .init()

        guard
            let firstDay = self.firstDayOfPeriod(containing: date, options: options),
            let lastDay = lastDayOfPeriod(containing: date, options: options)
        else {
            return 0
        }

        let days = Calendar.current.dateComponents([.day], from: firstDay, to: lastDay).day ?? 0
        return days + 1
    }
}
