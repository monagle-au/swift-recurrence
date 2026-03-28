//
//  RecurrenceState.swift
//  swift-recurrence
//
//  Created by David Monagle on 20/10/2025.
//

import SwiftUI
import RecurrenceRule

/// Observable state object that bridges individual UI field values to a ``RecurrenceRule``.
///
/// `RecurrenceState` is initialised from an existing `RecurrenceRule` and exposes flat,
/// bindable properties (frequency, interval, weekdays, etc.) that SwiftUI views can bind to
/// directly. The computed ``recurrenceRule`` property assembles those fields back into a
/// `RecurrenceRule` at any time.
///
/// This class is an implementation detail of ``RecurrenceRuleView`` and is not typically
/// used directly by consumers of the library.
@Observable class RecurrenceState {
    /// The selected recurrence frequency (daily, weekly, monthly, yearly).
    var frequency: FrequencyPicker.Option = .daily
    /// The interval multiplier applied to the selected frequency.
    var interval: Int
    /// The anchor start date for the recurrence.
    var start: Date
    /// The termination condition for the recurrence.
    var end: RecurrenceRule.End
    /// Whether the monthly/annual day selection is "every specific day" or "on the Nth weekday".
    var monthDaysSelection: MonthDaySelectionPicker.Option = .every
    /// The set of numbered days of the month selected for an `.every` pattern.
    var daysOfMonth: Set<Int> = []
    /// The ordinal position used for an `.onThe` monthly/annual pattern.
    var ordinal: RecurrenceMonthlyOrdinal = .first
    /// The selected weekdays, used for weekly frequency and `.onThe` monthly/annual patterns.
    var weekDays: Set<Locale.Weekday> = []
    /// The selected months used for an annual recurrence.
    var months: Set<RecurrenceMonth> = []

    /// Initialises the state by decomposing an existing `RecurrenceRule` into its constituent fields.
    /// - Parameter recurrenceRule: The rule whose values are used to populate the state.
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

    /// Assembles the current field values into a ``RecurrenceRule``.
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
        if lhs.start != rhs.start { return false }
        if lhs.end != rhs.end { return false }
        if lhs.monthDaysSelection != rhs.monthDaysSelection { return false }
        if lhs.daysOfMonth != rhs.daysOfMonth { return false }
        if lhs.ordinal != rhs.ordinal { return false }
        if lhs.weekDays != rhs.weekDays { return false }
        if lhs.months != rhs.months { return false }
        return true
    }
}
