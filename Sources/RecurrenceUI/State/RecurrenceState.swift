//
//  RecurrenceState.swift
//  swift-recurrence
//
//  Created by David Monagle on 20/10/2025.
//

import SwiftUI
import RecurrenceCore
import RecurrenceRule

@Observable class RecurrenceState {
    var frequency: FrequencyPicker.Option = .daily
    var interval: Int
    var start: Date
    var end: RecurrenceRule.End
    var monthDaysSelection: MonthDaySelectionPicker.Option = .every
    var daysOfMonth: Set<Int> = []
    var ordinal: RecurrenceOrdinal = .first
    var weekDays: Set<RecurrenceDayOfWeek> = []
    var months: Set<RecurrenceMonth> = []

    init(recurrenceRule: RecurrenceRule) {
        self.interval = recurrenceRule.interval
        self.start = recurrenceRule.start
        self.end = recurrenceRule.end
        switch recurrenceRule.frequency {
        case .daily(_):
            self.frequency = .daily
        case .weekly(let weekly):
            self.frequency = .weekly
            self.weekDays = weekly.weekDays
        case .monthly(let monthly):
            self.frequency = .monthly
            setMonthDaySelection(from: monthly.days)
        case .annually(let annually):
            self.frequency = .yearly
            self.months = annually.months
            setMonthDaySelection(from: annually.days)
        }
        
        func setMonthDaySelection(from days: RecurrenceRule.MonthDaysSelection) {
            switch days {
            case .every(let daysOfMonth):
                self.monthDaysSelection = .every
                self.daysOfMonth = daysOfMonth
            case .onThe(let ordinal, let weekDays):
                self.monthDaysSelection = .onThe
                self.ordinal = ordinal
                self.weekDays = weekDays
            }
        }
    }
    
    private var recurrenceMonthDays: RecurrenceRule.MonthDaysSelection {
        switch self.monthDaysSelection {
        case .every:
            return .every(daysOfMonth: self.daysOfMonth)
        case .onThe:
            return .onThe(ordinal: self.ordinal, weekDays: self.weekDays)
        }
    }
    
    var recurrenceRule: RecurrenceRule {
        switch frequency {
        case .daily:
            RecurrenceRule(
                interval: self.interval,
                frequency: .daily(.init()),
                start: self.start,
                end: self.end
            )
        case .weekly:
            RecurrenceRule(
                interval: self.interval,
                frequency: .weekly(.init(weekDays: self.weekDays)),
                start: self.start,
                end: self.end
            )
        case .monthly:
            RecurrenceRule(
                interval: self.interval,
                frequency: .monthly(.init(days: recurrenceMonthDays)),
                start: self.start,
                end: self.end
            )
        case .yearly:
            RecurrenceRule(
                interval: self.interval,
                frequency: .annually(.init(months: self.months, days: recurrenceMonthDays)),
                start: self.start,
                end: self.end
            )
        }
    }
}

extension RecurrenceState: Equatable {
    static func == (lhs: RecurrenceState, rhs: RecurrenceState) -> Bool {
        if lhs.frequency != rhs.frequency { return false }
        if lhs.interval != rhs.interval { return false }
        if lhs.monthDaysSelection != rhs.monthDaysSelection { return false }
        if lhs.daysOfMonth != rhs.daysOfMonth { return false }
        if lhs.ordinal != rhs.ordinal { return false }
        if lhs.weekDays != rhs.weekDays { return false }
        if lhs.months != rhs.months { return false }
        return true
    }
}
