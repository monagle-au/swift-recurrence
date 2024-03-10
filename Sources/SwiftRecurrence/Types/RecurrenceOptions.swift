//
//  RecurrenceOptions.swift
//  Recurrence
//
//  Created by David Monagle on 31/3/19.
//

import Foundation

public struct RecurrenceOptions : Codable {
    /// If set, the recurrence will begin at the given date
    public let startDate : Date?
    /// If set, the recurrence will end on or before the given date
    public let endDate : Date?
    /// Specified the calendar used for the recurrence
    public let calendar: Calendar
    
    /// Generates a date to start a new recurrence from. This will use the `startDate` if it is set, or the current date
    /// - Returns: The starting date
    public func generateStartDate() -> Date {
        startDate ?? calendar.startOfDay(for: Date())
    }
    
    public init(startDate: Date? = nil, endDate: Date? = nil, calendar: Calendar = Calendar.current) {
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
    }
    
    /// Returns true if the given `date` is within the constraints of the options.
    /// - Note: This cannot and does not take the limit into consideration
    /// - Parameter date: The date to check
    /// - Returns: `true` if the date is within the constraints  (if any) of ``startDate`` and ``endDate``

    public func canContain(date: Date) -> Bool {
        if let startDate = startDate, date < startDate { return false }
        if let endDate = endDate, date > endDate { return false }
        return true
    }
}

