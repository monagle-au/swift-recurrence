//
//  RecurrencRule.swift
//  swift-recurrence
//
//  Created by David Monagle on 26/8/2025.
//

import RecurrenceCore
import Foundation

struct RecurrenceRule: Sendable, Codable {
    let interval: Int
    let frequency: Frequency
}

extension RecurrenceRule {
    public enum Frequency: Sendable, Codable {
        case daily(Daily)
        case weekly(Weekly)
        case monthly(Monthly)
        case monthlyOrdinal(MonthlyOrdinal)
        case annually(Annually)
        case annuallyOrdinal(AnnuallyOrdinal)
    }
    
    public struct Daily : Sendable, Codable {
    }
    
    public struct Weekly : Sendable, Codable {
        let weekDays: Set<Locale.Weekday>
    }
    
    public struct Monthly : Sendable, Codable {
        let daysOfMonth: Set<Int>
    }
    
    public struct MonthlyOrdinal : Sendable, Codable {
        let ordinal: RecurrenceMonthlyOrdinal
        let weekDays: Set<RecurrenceDayOfWeek>
    }
    
    public struct Annually : Sendable, Codable {
        let months: Set<RecurrenceMonth>
        let daysOfMonth: Set<Int>
    }

    public struct AnnuallyOrdinal : Sendable, Codable {
        let months: Set<RecurrenceMonth>
        let ordinal: RecurrenceMonthlyOrdinal
        let weekDays: Set<RecurrenceDayOfWeek>
    }
}

extension RecurrenceRule {
    @available(macOS 15, *)
    public func calendarRecurrenceRule(_ calendar: Calendar) -> Calendar.RecurrenceRule {
        switch frequency {
        case .daily:
            return .init(calendar: calendar, frequency: .daily, interval: self.interval)
        case .weekly(let weekly):
            return .init(calendar: calendar, frequency: .weekly, interval: self.interval, weekdays: weekly.weekDays.map { .every($0)})
        case .monthly(let monthly):
            return .init(calendar: calendar, frequency: .monthly, interval: self.interval, daysOfTheMonth: Array(monthly.daysOfMonth))
        case .monthlyOrdinal(let monthlyOrdinal):
            
        case .annually(let annually):
        case .annuallyOrdinal(let annuallyOrdinal):
            
        }
    }
}
