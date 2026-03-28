//
//  RecurrenceRule+CalendarRecurrenceRuleTests.swift
//  recurrence-swift
//
//  Created by David Monagle on 28/3/2026.
//

import XCTest
@testable import RecurrenceRule

@available(macOS 15, iOS 18, *)
final class CalendarRecurrenceRuleTests: XCTestCase {
    let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Australia/Melbourne")!
        return cal
    }()

    /// Helper to create a date from components
    private func date(year: Int, month: Int, day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    /// Helper to extract (year, month, day) from a date for easy comparison
    private func components(_ date: Date) -> (year: Int, month: Int, day: Int) {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return (c.year!, c.month!, c.day!)
    }

    /// Helper to extract weekday from a date
    private func weekday(_ date: Date) -> Locale.Weekday {
        Locale.Weekday(date: date, calendar: calendar)
    }

    // MARK: - Daily

    func testDailyEveryDay() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .daily(.init()),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .daily)
        XCTAssertEqual(calRule.interval, 1)

        let range = start..<date(year: 2026, month: 1, day: 6)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 5)
        for (i, d) in dates.enumerated() {
            let c = components(d)
            XCTAssertEqual(c.day, 1 + i)
            XCTAssertEqual(c.month, 1)
        }
    }

    func testDailyEveryThirdDay() {
        let start = date(year: 2026, month: 3, day: 1)
        let rule = RecurrenceRule(
            interval: 3,
            frequency: .daily(.init()),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.interval, 3)

        let range = start..<date(year: 2026, month: 3, day: 16)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 5)
        let expectedDays = [1, 4, 7, 10, 13]
        for (i, d) in dates.enumerated() {
            XCTAssertEqual(components(d).day, expectedDays[i])
        }
    }

    // MARK: - Weekly

    func testWeeklyMonWedFri() {
        let start = date(year: 2026, month: 3, day: 2) // Monday
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .weekly(.init(weekDays: [.monday, .wednesday, .friday])),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .weekly)
        XCTAssertEqual(calRule.interval, 1)
        XCTAssertEqual(calRule.weekdays.count, 3)

        let range = start..<date(year: 2026, month: 3, day: 16)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Two weeks of Mon/Wed/Fri = 6 dates
        XCTAssertEqual(dates.count, 6)
        let expectedWeekdays: [Locale.Weekday] = [.monday, .wednesday, .friday, .monday, .wednesday, .friday]
        for (i, d) in dates.enumerated() {
            XCTAssertEqual(weekday(d), expectedWeekdays[i], "Date \(i): \(d)")
        }
    }

    func testWeeklyFortnightly() {
        let start = date(year: 2026, month: 1, day: 5) // Monday
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .weekly(.init(weekDays: [.monday])),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.interval, 2)

        let range = start..<date(year: 2026, month: 2, day: 28)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Every other Monday from Jan 5 → Jan 5, Jan 19, Feb 2, Feb 16 = 4
        XCTAssertEqual(dates.count, 4)
        let expectedDays = [(1, 5), (1, 19), (2, 2), (2, 16)]
        for (i, d) in dates.enumerated() {
            let c = components(d)
            XCTAssertEqual(c.month, expectedDays[i].0, "Date \(i)")
            XCTAssertEqual(c.day, expectedDays[i].1, "Date \(i)")
            XCTAssertEqual(weekday(d), .monday, "Date \(i)")
        }
    }

    func testWeeklyWeekends() {
        let start = date(year: 2026, month: 4, day: 4) // Saturday
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .weekly(.init(weekDays: [.saturday, .sunday])),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2026, month: 4, day: 20)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Apr 4 (Sat), 5 (Sun), 11 (Sat), 12 (Sun), 18 (Sat), 19 (Sun) = 6
        XCTAssertEqual(dates.count, 6)
        for d in dates {
            XCTAssertTrue(weekday(d) == .saturday || weekday(d) == .sunday)
        }
    }

    // MARK: - Monthly (specific days)

    func testMonthlyFirstAndFifteenth() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .every(daysOfMonth: [1, 15]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .monthly)

        let range = start..<date(year: 2026, month: 4, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Jan 1, Jan 15, Feb 1, Feb 15, Mar 1, Mar 15 = 6
        XCTAssertEqual(dates.count, 6)
        for d in dates {
            let c = components(d)
            XCTAssertTrue(c.day == 1 || c.day == 15)
        }
    }

    func testMonthlyEveryOtherMonth() {
        let start = date(year: 2026, month: 1, day: 10)
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .monthly(.init(days: .every(daysOfMonth: [10]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.interval, 2)

        let range = start..<date(year: 2026, month: 12, day: 31)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Jan 10, Mar 10, May 10, Jul 10, Sep 10, Nov 10 = 6
        XCTAssertEqual(dates.count, 6)
        let expectedMonths = [1, 3, 5, 7, 9, 11]
        for (i, d) in dates.enumerated() {
            let c = components(d)
            XCTAssertEqual(c.month, expectedMonths[i])
            XCTAssertEqual(c.day, 10)
        }
    }

    func testMonthlyDay31SkipsShortMonths() {
        let start = date(year: 2026, month: 1, day: 31)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .every(daysOfMonth: [31]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2026, month: 8, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Only months with 31 days: Jan 31, Mar 31, May 31, Jul 31
        XCTAssertEqual(dates.count, 4)
        let expectedMonths = [1, 3, 5, 7]
        for (i, d) in dates.enumerated() {
            let c = components(d)
            XCTAssertEqual(c.month, expectedMonths[i])
            XCTAssertEqual(c.day, 31)
        }
    }

    // MARK: - Monthly (ordinal)

    func testMonthlySecondTuesday() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .second, weekDays: [.tuesday]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .monthly)

        let range = start..<date(year: 2026, month: 4, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // 2nd Tuesday: Jan 13, Feb 10, Mar 10
        XCTAssertEqual(dates.count, 3)
        for d in dates {
            XCTAssertEqual(weekday(d), .tuesday)
            // Should be the 2nd Tuesday (day 8-14)
            let day = components(d).day
            XCTAssertTrue(day >= 8 && day <= 14, "Day \(day) should be 8-14 for 2nd occurrence")
        }
    }

    func testMonthlySecondLastFriday() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .secondLast, weekDays: [.friday]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertTrue(calRule.weekdays.contains(.nth(-2, .friday)))

        let range = start..<date(year: 2026, month: 4, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 3)
        for d in dates {
            XCTAssertEqual(weekday(d), .friday)
            // Verify it's the second-last Friday: the next Friday should be the last one
            let nextFriday = calendar.date(byAdding: .day, value: 7, to: d)!
            let fridayAfterThat = calendar.date(byAdding: .day, value: 14, to: d)!
            // Next Friday is still in same month, but the one after isn't
            XCTAssertEqual(
                calendar.component(.month, from: d),
                calendar.component(.month, from: nextFriday),
                "Next Friday should still be in the same month"
            )
            XCTAssertNotEqual(
                calendar.component(.month, from: d),
                calendar.component(.month, from: fridayAfterThat),
                "Friday two weeks later should be in a different month"
            )
        }
    }

    func testMonthlyLastFriday() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .last, weekDays: [.friday]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2026, month: 4, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Last Friday: Jan 30, Feb 27, Mar 27
        XCTAssertEqual(dates.count, 3)
        for d in dates {
            XCTAssertEqual(weekday(d), .friday)
            // Verify it's actually the last Friday by checking the next Friday is in a different month
            let nextFriday = calendar.date(byAdding: .day, value: 7, to: d)!
            XCTAssertNotEqual(
                calendar.component(.month, from: d),
                calendar.component(.month, from: nextFriday),
                "Should be the last Friday of the month"
            )
        }
    }

    func testMonthlyFirstWeekday() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .first, weekDays: [.monday, .tuesday, .wednesday, .thursday, .friday]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2026, month: 4, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // First Mon-Fri of each month = 5 weekdays × 3 months = 15
        XCTAssertEqual(dates.count, 15)
        for d in dates {
            let day = components(d).day
            // First occurrence of any weekday must be day 1-7
            XCTAssertTrue(day >= 1 && day <= 7, "Day \(day) should be 1-7 for first occurrence")
            XCTAssertTrue(weekday(d).isWeekday)
        }
    }

    // MARK: - Annually (specific days)

    func testAnnuallyJanAndJulFirst() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.january, .july], days: .every(daysOfMonth: [1]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .yearly)
        XCTAssertEqual(calRule.months.count, 2)

        let range = start..<date(year: 2028, month: 12, day: 31)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Jan 1 & Jul 1 for 2026, 2027, 2028 = 6
        XCTAssertEqual(dates.count, 6)
        for d in dates {
            let c = components(d)
            XCTAssertTrue(c.month == 1 || c.month == 7)
            XCTAssertEqual(c.day, 1)
        }
    }

    func testAnnuallyEveryOtherYear() {
        let start = date(year: 2026, month: 6, day: 15)
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .annually(.init(months: [.june], days: .every(daysOfMonth: [15]))),
            start: start,
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.interval, 2)

        let range = start..<date(year: 2035, month: 1, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // 2026, 2028, 2030, 2032, 2034 = 5
        XCTAssertEqual(dates.count, 5)
        let expectedYears = [2026, 2028, 2030, 2032, 2034]
        for (i, d) in dates.enumerated() {
            let c = components(d)
            XCTAssertEqual(c.year, expectedYears[i])
            XCTAssertEqual(c.month, 6)
            XCTAssertEqual(c.day, 15)
        }
    }

    func testAnnuallyMultipleMonthsMultipleDays() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.march, .september], days: .every(daysOfMonth: [1, 15]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2027, month: 12, day: 31)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Mar 1, Mar 15, Sep 1, Sep 15 for 2026 and 2027 = 8
        XCTAssertEqual(dates.count, 8)
        for d in dates {
            let c = components(d)
            XCTAssertTrue(c.month == 3 || c.month == 9)
            XCTAssertTrue(c.day == 1 || c.day == 15)
        }
    }

    // MARK: - Annually (ordinal)

    func testAnnuallyThirdMondayOfMarch() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.march], days: .onThe(ordinal: .third, weekDays: [.monday]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2029, month: 1, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // 3rd Monday of March for 2026, 2027, 2028 = 3
        XCTAssertEqual(dates.count, 3)
        for d in dates {
            let c = components(d)
            XCTAssertEqual(c.month, 3)
            XCTAssertEqual(weekday(d), .monday)
            // 3rd Monday is always day 15-21
            XCTAssertTrue(c.day >= 15 && c.day <= 21, "Day \(c.day) should be 15-21 for 3rd Monday")
        }
    }

    func testAnnuallyLastFridayOfMultipleMonths() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.june, .december], days: .onThe(ordinal: .last, weekDays: [.friday]))),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2028, month: 1, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        // Last Friday of Jun & Dec for 2026, 2027 = 4
        XCTAssertEqual(dates.count, 4)
        for d in dates {
            let c = components(d)
            XCTAssertTrue(c.month == 6 || c.month == 12)
            XCTAssertEqual(weekday(d), .friday)
            // Verify it's the last Friday
            let nextFriday = calendar.date(byAdding: .day, value: 7, to: d)!
            XCTAssertNotEqual(
                calendar.component(.month, from: d),
                calendar.component(.month, from: nextFriday)
            )
        }
    }

    // MARK: - End conditions

    func testEndNever() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .daily(.init()),
            start: start,
            end: .never
        )

        let range = start..<date(year: 2026, month: 1, day: 11)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 10)
    }

    func testEndAfterOccurrences() {
        let start = date(year: 2026, month: 1, day: 1)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .daily(.init()),
            start: start,
            end: .occurrences(5)
        )

        // Range is large but occurrences should limit results
        let range = start..<date(year: 2027, month: 1, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 5)
    }

    func testEndByDate() {
        let start = date(year: 2026, month: 1, day: 1)
        let endDate = date(year: 2026, month: 1, day: 5)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .daily(.init()),
            start: start,
            end: .date(endDate)
        )

        // Range extends past end date
        let range = start..<date(year: 2026, month: 2, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 5) // Jan 1-5 inclusive
        for d in dates {
            XCTAssertTrue(d <= endDate)
        }
    }

    func testEndOccurrencesWithWeekly() {
        let start = date(year: 2026, month: 3, day: 2) // Monday
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .weekly(.init(weekDays: [.monday, .friday])),
            start: start,
            end: .occurrences(4)
        )

        let range = start..<date(year: 2027, month: 1, day: 1)
        let dates = rule.recurrences(in: range, calendar: calendar)
        XCTAssertEqual(dates.count, 4)
        // Mon Mar 2, Fri Mar 6, Mon Mar 9, Fri Mar 13
        let expectedWeekdays: [Locale.Weekday] = [.monday, .friday, .monday, .friday]
        for (i, d) in dates.enumerated() {
            XCTAssertEqual(weekday(d), expectedWeekdays[i], "Date \(i)")
        }
    }

    // MARK: - Calendar.RecurrenceRule property verification

    func testDailyCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 5,
            frequency: .daily(.init()),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .daily)
        XCTAssertEqual(calRule.interval, 5)
        XCTAssertTrue(calRule.weekdays.isEmpty)
        XCTAssertTrue(calRule.daysOfTheMonth.isEmpty)
        XCTAssertTrue(calRule.months.isEmpty)
    }

    func testWeeklyCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .weekly(.init(weekDays: [.tuesday, .thursday])),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .weekly)
        XCTAssertEqual(calRule.interval, 2)
        XCTAssertEqual(calRule.weekdays.count, 2)
        // Verify weekdays are .every() type by checking they match the expected format
        XCTAssertTrue(calRule.weekdays.contains(.every(.tuesday)))
        XCTAssertTrue(calRule.weekdays.contains(.every(.thursday)))
    }

    func testMonthlyEveryCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .every(daysOfMonth: [5, 20]))),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .monthly)
        XCTAssertEqual(calRule.interval, 1)
        XCTAssertEqual(Set(calRule.daysOfTheMonth), [5, 20])
        XCTAssertTrue(calRule.weekdays.isEmpty)
    }

    func testMonthlyOrdinalCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .fourth, weekDays: [.wednesday]))),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .monthly)
        XCTAssertEqual(calRule.weekdays.count, 1)
        XCTAssertTrue(calRule.daysOfTheMonth.isEmpty)
        XCTAssertTrue(calRule.weekdays.contains(.nth(4, .wednesday)))
    }

    func testMonthlyLastOrdinalCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .last, weekDays: [.sunday]))),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertTrue(calRule.weekdays.contains(.nth(-1, .sunday)))
    }

    func testAnnuallyCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.february, .august], days: .every(daysOfMonth: [14]))),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .yearly)
        XCTAssertEqual(calRule.interval, 1)
        XCTAssertEqual(calRule.months.count, 2)
        XCTAssertTrue(calRule.months.contains(Calendar.RecurrenceRule.Month(2)))
        XCTAssertTrue(calRule.months.contains(Calendar.RecurrenceRule.Month(8)))
        XCTAssertEqual(calRule.daysOfTheMonth, [14])
        XCTAssertTrue(calRule.weekdays.isEmpty)
    }

    func testAnnuallyOrdinalCalendarRuleProperties() {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.november], days: .onThe(ordinal: .fourth, weekDays: [.thursday]))),
            start: date(year: 2026, month: 1, day: 1),
            end: .never
        )
        let calRule = rule.calendarRecurrenceRule(calendar)
        XCTAssertEqual(calRule.frequency, .yearly)
        XCTAssertEqual(calRule.months.count, 1)
        XCTAssertTrue(calRule.months.contains(Calendar.RecurrenceRule.Month(11)))
        XCTAssertEqual(calRule.weekdays.count, 1)
        XCTAssertTrue(calRule.weekdays.contains(.nth(4, .thursday)))
        XCTAssertTrue(calRule.daysOfTheMonth.isEmpty)
    }
}
