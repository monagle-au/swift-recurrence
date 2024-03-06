//
//  Calander+Interval.swift
//  Recurrence
//
//  Created by David Monagle on 29/3/19.
//

import Foundation

public extension Calendar {
    /// Returns a new Date representing the date calculated by adding an interval to a given date.
    ///
    /// - Parameters:
    ///   - interval: A RecurrenceInterval to be added to the date.
    ///   - date: The starting date.
    ///   - wrappingComponents: If true, the component should be incremented and wrap around to zero/one on overflow,
    ///     and should not cause higher components to be incremented. The default value is false.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func date(byAdding interval: Interval, to date: Date = Date(), wrappingComponents: Bool = false) -> Date? {
        guard let result = self.date(byAdding: interval.dateComponents(), to: date, wrappingComponents: wrappingComponents) else { return nil }
        return self.startOfDay(for: result)
    }

    /// Returns a new Date representing the date calculated by subtracting an interval from a given date.
    ///
    /// - Parameters:
    ///   - interval: A RecurrenceInterval to be subtracted to the date.
    ///   - date: The starting date.
    ///   - wrappingComponents: If true, the component should be decremented and wrap around on overflow,
    ///     and should not cause higher components to be decremented. The default value is false.
    /// - Returns: A new date, or nil if a date could not be calculated with the given input.
    func date(bySubtracting interval: Interval, from date: Date = Date(), wrappingComponents: Bool = false) -> Date? {
        guard let result = self.date(byAdding: interval.negativeDateComponents(), to: date, wrappingComponents: wrappingComponents) else { return nil }
        return self.startOfDay(for: result)
    }
}
