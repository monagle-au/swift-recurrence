//
//  LocaleWeekday+.swift
//  swift-recurrence
//
//  Created by David Monagle on 30/8/2025.
//

import Foundation

extension Locale.Weekday {
    public init(date: Date, calendar: Calendar = Calendar.current) {
        let dayNumber = calendar.component(.weekday, from: date)
        self.init(dayNumber: dayNumber)
    }

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

    public func next() -> Locale.Weekday {
        .init(dayNumber: self.dayNumber + 1)
    }
}

extension Locale.Weekday {
    public static func only(_ days : Locale.Weekday ...) -> Set<Locale.Weekday> {
        return Set<Locale.Weekday>(days)
    }

    public static let all = Set<Locale.Weekday>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    public static let weekdays: Set<Locale.Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: Set<Locale.Weekday> = [.saturday, .sunday]

    public var isWeekday : Bool {
        get { return Locale.Weekday.weekdays.contains(self) }
    }

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
