//
//  RecurrenceSelector.swift
//  Recurrence
//
//  Created by David Monagle on 29/3/19.
//

import Foundation

/// A type that can provide recurring dates.
public protocol Recurrable {
    /// An ``Interval.Unit`` signifying the possible granularity of this Recurrable.
    var intervalUnit: Interval.Unit { get }
    
    /// Checks if a date is a match with this Recurrence.
    ///
    /// - Parameters:
    ///   - date: The date to check.
    ///   - options: RecurrenceOptions
    /// - Returns: True if the date matches this Recurrence.
    func matches(date: Date, options: RecurrenceOptions) -> Bool

    /// Returns the first possible date for this Recurrence based on the given date.
    ///
    /// - Parameters:
    ///   - date: The date to check
    ///   - options: RecurrenceOptions
    /// - Returns: The first possible date, or nil if the given date does not fall within this Recurrence.
    func first(for date: Date, options: RecurrenceOptions) -> Date?
    
    /// Returns the last possible date for this Recurrence based on the given date.
    ///
    /// - Parameters:
    ///   - date: The date to check
    ///   - options: RecurrenceOptions
    /// - Returns: The last possible date, or nil if the given date does not fall within this Recurrence.
    func last(for date: Date, options: RecurrenceOptions) -> Date?
    
    /// Returns the first matching date before the given date for the options.
    ///
    /// - Parameters:
    ///   - date: The date to look back from.
    ///   - options: RecurrenceOptions
    /// - Returns: The first matching date or nil if there are no more matching dates for the Recurrence.
    func date(before date: Date, options: RecurrenceOptions) -> Date?

    /// Returns the first matching date after the given date for the options.
    ///
    /// - Parameters:
    ///   - date: The date to look forward from.
    ///   - options: RecurrenceOptions
    /// - Returns: The first matching date or nil if there are no more matching dates for the Recurrence.
    func date(after date: Date, options: RecurrenceOptions) -> Date?
}

public extension Recurrable {
    /// Return the first date for the given context
    ///
    /// - Parameter options: RecurrenceOptions
    /// - Returns: <#return value description#>
    func first(from: Date? = nil, options: RecurrenceOptions) -> Date? {
        let from = from ?? options.generateStartDate()
        if matches(date: from, options: options) {
            return from
        }
        return date(after: from, options: options)
    }
    
    func iterate(from date: Date, options: RecurrenceOptions, until: (Date) -> Bool) -> Date? {
        var check : Date? = date
        while let validDate = check, !until(validDate) {
            check = self.date(after: validDate, options: options)
        }
        return check
    }
}

