//
//  Interval.swift
//  Recurrence
//
//  Created by David Monagle
//

import Foundation

public struct Interval : Equatable, Hashable {
    var number: Int
    var unit: Unit
    
    public init(_ interval: Int = 1, _ unit: Unit) {
        self.number = interval
        self.unit = unit
    }
}

extension Interval {
    public enum Unit: String, Codable, Equatable, Hashable {
        case day
        case week
        case month
        case year
    }
}

extension Interval {
    func dateComponents() -> DateComponents {
        switch self.unit {
        case .day:
            return DateComponents(day: self.number)
        case .week:
            return DateComponents(day: self.number * 7)
        case .month:
            return DateComponents(month: self.number)
        case .year:
            return DateComponents(year: self.number)
        }
    }

    func negativeDateComponents() -> DateComponents {
        switch self.unit {
        case .day:
            return DateComponents(day: self.number * -1)
        case .week:
            return DateComponents(day: self.number * -7)
        case .month:
            return DateComponents(month: self.number * -1)
        case .year:
            return DateComponents(year: self.number * -1)
        }
    }
}

public extension Int {
    var recurringDays : Interval { return Interval(self, .day) }
    var recurringWeeks : Interval { return Interval(self, .week) }
    var recurringMonths : Interval { return Interval(self, .month) }
    var recurringYears : Interval { return Interval(self, .year) }
}
