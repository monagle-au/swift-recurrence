//
//  LocaleWeekday+.swift
//  swift-recurrence
//
//  Created by David Monagle on 30/8/2025.
//

import Foundation

extension Locale.Weekday {
    /// Initialises a `Locale.Weekday` from the weekday component of a date.
    ///
    /// - Parameters:
    ///   - date: The date whose weekday component is extracted.
    ///   - calendar: The calendar used for extraction (default `.current`).
    public init(date: Date, calendar: Calendar = Calendar.current) {
        let dayNumber = calendar.component(.weekday, from: date)
        self.init(dayNumber: dayNumber)
    }

    /// Initialises a `Locale.Weekday` from a 1-based weekday number (1 = Sunday … 7 = Saturday).
    ///
    /// Values outside 1–7 are wrapped using modular arithmetic so callers can safely pass
    /// values produced by incrementing ``dayNumber``.
    ///
    /// - Parameter dayNumber: A weekday number in the range 1–7 (or any integer that wraps into range).
    public init(dayNumber: Int) {
        var adjusted = dayNumber.remainderReportingOverflow(dividingBy: 7).partialValue
        if adjusted < 1 { adjusted = 7 + adjusted }

        switch adjusted {
        case 1: self = .sunday
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        default : fatalError("day number outside of range 1..7")
        }
    }

    /// The 1-based day number for this weekday (1 = Sunday, 7 = Saturday).
    public var dayNumber: Int {
        switch self {
            case .sunday: return 1
            case .monday: return 2
            case .tuesday: return 3
            case .wednesday: return 4
            case .thursday: return 5
            case .friday: return 6
            case .saturday: return 7
            default : fatalError("a new day of week has been added")
        }
    }

    /// Returns the weekday that immediately follows this one, wrapping Saturday → Sunday.
    public func next() -> Locale.Weekday {
        .init(dayNumber: self.dayNumber + 1)
    }
}

extension Locale.Weekday {
    /// Creates a set containing only the specified weekdays.
    ///
    /// A convenience for inline construction, e.g. `Locale.Weekday.only(.monday, .wednesday)`.
    /// - Parameter days: The weekdays to include.
    /// - Returns: A set containing exactly the provided days.
    public static func only(_ days : Locale.Weekday ...) -> Set<Locale.Weekday> {
        return Set<Locale.Weekday>(days)
    }

    /// A set containing all seven days of the week.
    public static let all = Set<Locale.Weekday>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    /// A set containing the five standard weekdays (Monday – Friday).
    public static let weekdays: Set<Locale.Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    /// A set containing the two weekend days (Saturday and Sunday).
    public static let weekend: Set<Locale.Weekday> = [.saturday, .sunday]

    /// Returns `true` when this day falls on a standard weekday (Monday – Friday).
    public var isWeekday : Bool {
        get { return Locale.Weekday.weekdays.contains(self) }
    }

    /// Returns `true` when this day falls on the weekend (Saturday or Sunday).
    public var isWeekend : Bool {
        get { return Locale.Weekday.weekend.contains(self) }
    }
}

extension Locale.Weekday : @retroactive Comparable {
    public static func < (lhs: Locale.Weekday, rhs: Locale.Weekday) -> Bool {
        lhs.dayNumber < rhs.dayNumber
    }
}

extension Set where Element == Locale.Weekday {
    public static let weekdays = Locale.Weekday.weekdays
    public static let weekend = Locale.Weekday.weekend
    public static let all = Locale.Weekday.all
}
