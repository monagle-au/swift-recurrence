//
//  Calendar+.swift
//  swift-recurrence
//
//  Created by David Monagle on 26/8/2025.
//

import Foundation

public extension Calendar {
    /// Returns the number of days in the month of the given date.
    ///
    /// - Parameter date: The date for the month to be determined.
    /// - Returns: The number of days in the month.
    func daysInMonth(of date: Date) -> Int {
        self.range(of: .day, in: .month, for: date)!.count
    }
}
