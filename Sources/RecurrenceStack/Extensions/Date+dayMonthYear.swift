//
//  Date+dayMonthYear.swift
//
//  Created by David Monagle
//

import RecurrenceCore
import Foundation

extension Date {
    /// Returns a date representing midnight of the given day, month and year.
    ///
    /// - Parameters:
    ///   - day: Day
    ///   - month: Month
    ///   - year: Year
    ///   - calendar: The calendar that will be used to build the Date, defaults to Calendar.current
    /// - Returns: A Date representing midnight in the `calendar` for the given day, month and year.
    public static func dayMonthYear(_ day: Int, _ month: RecurrenceMonth, _ year: Int, calendar: Calendar = Calendar.current) -> Date {
        return calendar.date(from: DateComponents(year: year, month: month.rawValue, day: day))!
    }
}


