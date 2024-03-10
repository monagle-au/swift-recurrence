import Foundation

public extension RecurrableStack {
    static func dailyStack(every: Int = 1) -> RecurrableStack {
        [
            every.recurringDays
        ]
    }
    
    static func weeklyStack(every: Int = 1, days: Set<RecurrenceDayOfWeek>) -> RecurrableStack {
        [
            every.recurringWeeks,
            RecurrenceDaysInWeekSelector(daysOfWeek: days)
        ]
    }
    
    static func monthlyStack(every: Int = 1, days: Set<Int>) -> RecurrableStack {
        [
            every.recurringMonths,
            RecurrenceDaysInMonthSelector(days: days)
        ]
    }
    
    static func monthlyOrdinalStack(every: Int = 1, onThe ordinal: RecurrenceMonthlyOrdinal, _ daysOfWeek: Set<RecurrenceDayOfWeek>) -> RecurrableStack {
        [
            every.recurringMonths,
            RecurrenceOrdinalDaysInMonthSelector(ordinal: ordinal, days: daysOfWeek)
        ]
    }
    
    static func annualStack(every: Int = 1, in months: Set<RecurrenceMonth>, days: Set<Int>) -> RecurrableStack {
        [
            every.recurringYears,
            RecurrenceMonthsInYearSelector(months: months),
            RecurrenceDaysInMonthSelector(days: days)
        ]
    }

    static func annuallyOrdinalStack(every: Int = 1, in months: Set<RecurrenceMonth>, onThe ordinal: RecurrenceMonthlyOrdinal, _ daysOfWeek: Set<RecurrenceDayOfWeek>) -> RecurrableStack {
        [
            every.recurringYears,
            RecurrenceMonthsInYearSelector(months: months),
            RecurrenceOrdinalDaysInMonthSelector(ordinal: ordinal, days: daysOfWeek)
        ]
    }
}
