import RecurrenceCore
import Foundation

public extension RecurrenceStack {
    static func dailyStack(every: Int = 1) -> RecurrenceStack {
        [
            every.recurringDays
        ]
    }
    
    static func weeklyStack(every: Int = 1, days: Set<RecurrenceDayOfWeek>) -> RecurrenceStack {
        [
            every.recurringWeeks,
            RecurrenceDaysInWeekSelector(daysOfWeek: days)
        ]
    }
    
    static func monthlyStack(every: Int = 1, days: Set<Int>) -> RecurrenceStack {
        [
            every.recurringMonths,
            RecurrenceDaysInMonthSelector(days: days)
        ]
    }
    
    static func monthlyOrdinalStack(every: Int = 1, onThe ordinal: RecurrenceMonthlyOrdinal, _ daysOfWeek: Set<RecurrenceDayOfWeek>) -> RecurrenceStack {
        [
            every.recurringMonths,
            RecurrenceOrdinalDaysInMonthSelector(ordinal: ordinal, days: daysOfWeek)
        ]
    }
    
    static func annualStack(every: Int = 1, in months: Set<RecurrenceMonth>, days: Set<Int>) -> RecurrenceStack {
        [
            every.recurringYears,
            RecurrenceMonthsInYearSelector(months: months),
            RecurrenceDaysInMonthSelector(days: days)
        ]
    }

    static func annuallyOrdinalStack(every: Int = 1, in months: Set<RecurrenceMonth>, onThe ordinal: RecurrenceMonthlyOrdinal, _ daysOfWeek: Set<RecurrenceDayOfWeek>) -> RecurrenceStack {
        [
            every.recurringYears,
            RecurrenceMonthsInYearSelector(months: months),
            RecurrenceOrdinalDaysInMonthSelector(ordinal: ordinal, days: daysOfWeek)
        ]
    }
}
