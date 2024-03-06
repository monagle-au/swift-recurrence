//
//  Calandar+Helpers.swift
//
//  Created by David Monagle
//  Copyright © 2023 Monagle. All rights reserved.
//

import Foundation

public extension Calendar {
    /// Returns the number of days in the month of the given date.
    ///
    /// - Parameter date: The date for the month to be determined.
    /// - Returns: The number of days in the month.
    func daysInMonth(of date: Date) -> Int {
        guard let range = self.range(of: .day, in: .month, for: date) else { fatalError("Unable to determine the number of days in month for: \(date)") }
        return range.count
    }
    
    func datesAreWithinSameWeek(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        
        // Find the start of the day for date1 to ensure consistent comparison
        let startOfDate1 = calendar.startOfDay(for: date1)
        
        // Determine how many days to subtract to get back to the previous Sunday
        let weekday = calendar.component(.weekday, from: startOfDate1)
        // Adjusting the calculation to ensure Sunday is treated as the start of the week
        let daysToSubtract = weekday == 1 ? 0 : weekday - 1
        
        let previousSunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: startOfDate1)!
        
        // Calculate the difference in days from the previous Sunday (or the day itself if Sunday) to date2
        let daysBetween = calendar.dateComponents([.day], from: previousSunday, to: date2).day!
        
        return daysBetween < 7
    }

    
    /// Returns the number of days in the year of the given date.
    ///
    /// - Parameter date: The date for the year to be determined.
    /// - Returns: The number of days in the year
    func daysInYear(of date: Date) -> Int {
        guard let range = self.range(of: .day, in: .year, for: date) else { fatalError("Unable to determine the number of days in year for: \(date)") }
        return range.count
    }

    /// Returns the input date after shifting the day to the first day of the week.
    ///
    /// - Parameter date: The date to be
    /// - Returns: The date for first day of the week. All other date components are left the same.
    func startOfWeek(for date: Date = Date()) -> Date {
        let startOfDay = self.startOfDay(for: date)
        let dayOfWeek = self.component(.weekday, from: startOfDay)
        let daysToAdd = DateComponents(day: 1 - dayOfWeek)
        return self.date(byAdding: daysToAdd, to: startOfDay)!
    }

    /// Get the first day of the month for the given date.
    ///
    /// - Parameter date: The date to get the first day of the month for.
    /// - Returns: A date representing the first day of the month.
    func startOfMonth(for date: Date = Date()) -> Date {
        var components = self.dateComponents([.month, .year], from: date)
        components.day = 1
        return self.date(from: components)!
    }

    /// Get the first day of the year for the given date.
    ///
    /// - Parameter date: The date to get the first day of the year for.
    /// - Returns: A date representing the first day of the year.
    func startOfYear(for date: Date = Date()) -> Date {
        let year = self.component(.year, from: date)
        let components = DateComponents(year: year, month: 1, day: 1)
        return self.date(from: components)!
    }
 
    /// Checks to see if two dates have matching components.
    ///
    /// - Parameters:
    ///   - components: A set of components to compare. Eg: [.month, year]
    ///   - date1: The first date to compare.
    ///   - date2: The second date to compare
    /// - Returns: True if the components of the two dates match.
    func compare(date date1: Date, and date2: Date, toGranularity components: Set<Calendar.Component>) -> Bool {
        let date1Components = self.dateComponents(components, from: date1)
        let date2Components = self.dateComponents(components, from: date2)
        return date1Components == date2Components
    }
    
    func recurrenceDayOfWeek(for date: Date) -> RecurrenceDayOfWeek {
        let weekdayNumber = self.component(.weekday, from: date)
        return RecurrenceDayOfWeek(rawValue: weekdayNumber)!
    }
}
