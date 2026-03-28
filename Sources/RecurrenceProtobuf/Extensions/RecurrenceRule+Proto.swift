//
//  RecurrenceRule+Proto.swift
//  recurrence-swift
//
//  Created by David Monagle on 28/3/2026.
//

import Foundation
import RecurrenceRule
import SwiftProtobuf

// MARK: - Weekday

extension RecurrenceProtoV1Weekday {
    public init(_ weekday: Locale.Weekday) {
        switch weekday {
        case .sunday: self = .sunday
        case .monday: self = .monday
        case .tuesday: self = .tuesday
        case .wednesday: self = .wednesday
        case .thursday: self = .thursday
        case .friday: self = .friday
        case .saturday: self = .saturday
        @unknown default: self = .unspecified
        }
    }
}

extension Locale.Weekday {
    public init(proto: RecurrenceProtoV1Weekday) throws {
        switch proto {
        case .sunday: self = .sunday
        case .monday: self = .monday
        case .tuesday: self = .tuesday
        case .wednesday: self = .wednesday
        case .thursday: self = .thursday
        case .friday: self = .friday
        case .saturday: self = .saturday
        case .unspecified, .UNRECOGNIZED:
            throw RecurrenceProtoV1Error.invalidWeekday(proto.rawValue)
        }
    }
}

// MARK: - Month

extension RecurrenceProtoV1Month {
    public init(_ month: RecurrenceMonth) {
        self = RecurrenceProtoV1Month(rawValue: month.rawValue) ?? .unspecified
    }
}

extension RecurrenceMonth {
    public init(proto: RecurrenceProtoV1Month) throws {
        guard let month = RecurrenceMonth(rawValue: proto.rawValue) else {
            throw RecurrenceProtoV1Error.invalidMonth(proto.rawValue)
        }
        self = month
    }
}

// MARK: - MonthlyOrdinal

extension RecurrenceProtoV1MonthlyOrdinal {
    public init(_ ordinal: RecurrenceMonthlyOrdinal) {
        switch ordinal {
        case .first: self = .first
        case .second: self = .second
        case .third: self = .third
        case .fourth: self = .fourth
        case .fifth: self = .fifth
        case .secondLast: self = .secondLast
        case .last: self = .last
        }
    }
}

extension RecurrenceMonthlyOrdinal {
    public init(proto: RecurrenceProtoV1MonthlyOrdinal) throws {
        switch proto {
        case .first: self = .first
        case .second: self = .second
        case .third: self = .third
        case .fourth: self = .fourth
        case .fifth: self = .fifth
        case .secondLast: self = .secondLast
        case .last: self = .last
        case .unspecified, .UNRECOGNIZED:
            throw RecurrenceProtoV1Error.invalidOrdinal(proto.rawValue)
        }
    }
}

// MARK: - MonthDaysSelection

extension RecurrenceProtoV1MonthDaysSelection {
    public init(_ selection: RecurrenceRule.MonthDaysSelection) {
        switch selection {
        case .every(let daysOfMonth):
            var every = EveryDay()
            every.daysOfMonth = daysOfMonth.sorted().map { Int32($0) }
            self.selection = .every(every)
        case .onThe(let ordinal, let weekDays):
            var onThe = OnThe()
            onThe.ordinal = .init(ordinal)
            onThe.weekdays = weekDays.sorted().map { .init($0) }
            self.selection = .onThe(onThe)
        }
    }
}

extension RecurrenceRule.MonthDaysSelection {
    public init(proto: RecurrenceProtoV1MonthDaysSelection) throws {
        guard let selection = proto.selection else {
            throw RecurrenceProtoV1Error.missingMonthDaysSelection
        }
        switch selection {
        case .every(let every):
            self = .every(daysOfMonth: Set(every.daysOfMonth.map { Int($0) }))
        case .onThe(let onThe):
            let ordinal = try RecurrenceMonthlyOrdinal(proto: onThe.ordinal)
            let weekDays = try Set(onThe.weekdays.map { try Locale.Weekday(proto: $0) })
            self = .onThe(ordinal: ordinal, weekDays: weekDays)
        }
    }
}

// MARK: - RecurrenceRule

extension RecurrenceProtoV1RecurrenceRule {
    public init(_ rule: RecurrenceRule) {
        self.init()
        self.interval = Int32(rule.interval)
        self.start = .init(date: rule.start)
        switch rule.end {
        case .never:
            self.end = nil
        case .date(let date):
            self.end = .endDate(.init(date: date))
        case .occurrences(let count):
            self.end = .endOccurrences(Int32(count))
        }
        switch rule.frequency {
        case .daily:
            self.frequency = .daily(.init())
        case .weekly(let weekly):
            var w = Weekly()
            w.weekdays = weekly.weekDays.sorted().map { .init($0) }
            self.frequency = .weekly(w)
        case .monthly(let monthly):
            var m = Monthly()
            m.days = .init(monthly.days)
            self.frequency = .monthly(m)
        case .annually(let annually):
            var a = Annually()
            a.months = annually.months.sorted().map { .init($0) }
            a.days = .init(annually.days)
            self.frequency = .annually(a)
        }
    }
}

extension RecurrenceRule {
    public init(proto: RecurrenceProtoV1RecurrenceRule) throws {
        let interval = Int(proto.interval)

        let start = proto.start.date

        let end: RecurrenceRule.End
        switch proto.end {
        case .endDate(let timestamp):
            end = .date(timestamp.date)
        case .endOccurrences(let count):
            end = .occurrences(Int(count))
        case nil:
            end = .never
        }

        guard let protoFrequency = proto.frequency else {
            throw RecurrenceProtoV1Error.missingFrequency
        }

        let frequency: RecurrenceRule.Frequency
        switch protoFrequency {
        case .daily:
            frequency = .daily(.init())
        case .weekly(let w):
            let weekDays = try Set(w.weekdays.map { try Locale.Weekday(proto: $0) })
            frequency = .weekly(.init(weekDays: weekDays))
        case .monthly(let m):
            let days = try RecurrenceRule.MonthDaysSelection(proto: m.days)
            frequency = .monthly(.init(days: days))
        case .annually(let a):
            let months = try Set(a.months.map { try RecurrenceMonth(proto: $0) })
            let days = try RecurrenceRule.MonthDaysSelection(proto: a.days)
            frequency = .annually(.init(months: months, days: days))
        }

        self.init(interval: interval, frequency: frequency, start: start, end: end)
    }
}

// MARK: - Errors

public enum RecurrenceProtoV1Error: Error, Sendable {
    case invalidWeekday(Int)
    case invalidMonth(Int)
    case invalidOrdinal(Int)
    case missingFrequency
    case missingMonthDaysSelection
}
