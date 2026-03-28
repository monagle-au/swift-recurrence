//
//  RecurrenceSelectorTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 30/3/19.
//

import XCTest
import RecurrenceCore
@testable import RecurrenceStack

class RecurrenceSelectorTests: XCTestCase {
    // MARK: - RecurrenceDaysInWeekSelector
    
    func testRecurrenceDaysInWeekSelectorMatches() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.monday, .wednesday, .friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(30, .december, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(31, .december, 2018), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .january, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(2, .january, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(3, .january, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(4, .january, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .january, 2019), options: options))
    }
    
    func testRecurrenceDaysInWeekSelectorFirst() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.monday, .wednesday, .friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(8, .december, 2019), options: options), .dayMonthYear(9, .december, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(9, .december, 2019), options: options), .dayMonthYear(9, .december, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(12, .december, 2019), options: options), .dayMonthYear(9, .december, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(14, .december, 2019), options: options), .dayMonthYear(9, .december, 2019))
        
        // Test wrapping of years
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .january, 2020), options: options), .dayMonthYear(30, .december, 2019))
    }
    
    func testRecurrenceDaysInWeekSelectorLast() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.monday, .wednesday, .friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(8, .december, 2019), options: options), .dayMonthYear(13, .december, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(9, .december, 2019), options: options), .dayMonthYear(13, .december, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(12, .december, 2019), options: options), .dayMonthYear(13, .december, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(14, .december, 2019), options: options), .dayMonthYear(13, .december, 2019))
        
        // Test wrapping of years
        let tuesdays = RecurrenceDaysInWeekSelector(daysOfWeek: [.tuesday])
        XCTAssertEqual(tuesdays.last(for: .dayMonthYear(1, .january, 2020), options: options), .dayMonthYear(31, .december, 2019))
    }
    
    func testRecurrenceDaysInWeekSelectorBeforeAndAfter() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.tuesday, .thursday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .april, 2019), options: options))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(2, .april, 2019))
        XCTAssertNil(selector.date(before: .dayMonthYear(2, .april, 2019), options: options))
        XCTAssertEqual(selector.date(after: .dayMonthYear(2, .april, 2019), options: options), .dayMonthYear(4, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(3, .april, 2019), options: options), .dayMonthYear(2, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(3, .april, 2019), options: options), .dayMonthYear(4, .april, 2019))
        XCTAssertNil(selector.date(after: .dayMonthYear(4, .april, 2019), options: options))
    }
    
    // MARK: - RecurrenceMonthsInYearSelector

    func testRecurrenceMonthsInYearSelectorMatches() {
        let selector = RecurrenceMonthsInYearSelector(months: [.march, .april, .december])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .january, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(25, .march, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .april, 2018), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(18, .june, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(1, .december, 2018), options: options))
    }
    
    func testRecurrenceMonthsInYearSelectorFirst() {
        let selector = RecurrenceMonthsInYearSelector(months: [.march, .april, .december])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(7, .april, 2019), options: options), .dayMonthYear(1, .march, 2019))
    }
    
    func testRecurrenceMonthsInYearSelectorLast() {
        let selector = RecurrenceMonthsInYearSelector(months: [.march, .april, .december])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .april, 2019), options: options), .dayMonthYear(31, .december, 2019))
    }
    
    func testRecurrenceMonthsInYearSelectorBeforeAndAfter() {
        let selector = RecurrenceMonthsInYearSelector(months: [.march, .april, .november])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .february, 2019), options: options)) // Outside
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .march, 2019), options: options))     // On
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .march, 2019), options: options))    // Inside
        
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(1, .march, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .may, 2019), options: options), .dayMonthYear(1, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .december, 2019), options: options), .dayMonthYear(1, .november, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(10, .february, 2019), options: options), .dayMonthYear(1, .march, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .march, 2019), options: options), .dayMonthYear(1, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(10, .march, 2019), options: options), .dayMonthYear(1, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(1, .november, 2019))
        
        XCTAssertNil(selector.date(after: .dayMonthYear(10, .november, 2019), options: options)) // Inside
        XCTAssertNil(selector.date(after: .dayMonthYear(30, .november, 2019), options: options)) // On
        XCTAssertNil(selector.date(after: .dayMonthYear(1, .december, 2019), options: options))  // Outside
    }
    
    // MARK: - RecurrenceDaysInMonthSelector

    func testRecurrenceDaysInMonthSelectorMatches() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .december, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .december, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(31, .december, 2018), options: options))
    }
    
    func testRecurrenceDaysInMonthSelectorFirst() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 19, 30, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(7, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
    }
    
    func testRecurrenceDaysInMonthSelectorLast() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 19, 30, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .april, 2019), options: options), .dayMonthYear(30, .april, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .february, 2019), options: options), .dayMonthYear(19, .february, 2019))
    }
    
    func testRecurrenceDaysInMonthSelectorMatchesBeforeAndAfter() {
        let selector = RecurrenceDaysInMonthSelector(days: [2, 12, 17, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .april, 2019), options: options))
        XCTAssertNil(selector.date(before: .dayMonthYear(2, .april, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(15, .april, 2019), options: options), .dayMonthYear(12, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .april, 2019), options: options), .dayMonthYear(12, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(2, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(2, .april, 2019), options: options), .dayMonthYear(12, .april, 2019))
        XCTAssertNil(selector.date(after: .dayMonthYear(17, .april, 2019), options: options))
    }
    
    // MARK: - RecurrenceOrdinalDaysInMonthSelector
    func testOrdinalRangeOfDays() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2019))

        do {
            let range = RecurrenceOrdinal.first.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 1)
            XCTAssertEqual(range?.last, 7)
        }

        do {
            let range = RecurrenceOrdinal.second.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 8)
            XCTAssertEqual(range?.last, 14)
        }

        do {
            let range = RecurrenceOrdinal.third.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 15)
            XCTAssertEqual(range?.last, 21)
        }

        do {
            let range = RecurrenceOrdinal.fourth.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 22)
            XCTAssertEqual(range?.last, 28)
        }

        do {
            let range = RecurrenceOrdinal.fifth.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 29)
            XCTAssertEqual(range?.last, 30)
        }

        do {
            let range = RecurrenceOrdinal.fifth.daysOfMonth(for: .dayMonthYear(1, .february, 2019), options: options)
            XCTAssertNil(range)
        }

        do {
            let range = RecurrenceOrdinal.last.daysOfMonth(for: .dayMonthYear(1, .april, 2019), options: options)
            XCTAssertEqual(range?.first, 24)
            XCTAssertEqual(range?.last, 30)
        }
    }
    
    func testRecurrenceOrdinalDaysInMonthSelectorMatchingDayOfMonth() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2019))
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .first, days: [.sunday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 7)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .second, days: [.tuesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 9)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .third, days: [.friday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 19)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fourth, days: [.monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 22)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 29)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.friday, .thursday, .wednesday, .monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 29)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.friday, .thursday, .wednesday, .tuesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 30)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.friday])
            XCTAssertNil(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options))
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.monday, .tuesday, .wednesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 30)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 30)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .april, 2019), options: options), 29)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.sunday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .august, 2019), options: options), 25)
        }

    }

    func testRecurrenceOrdinalDaysInMonthSelectorMatches() {
        let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.sunday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2019))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(20, .january, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(27, .january, 2019), options: options))

        XCTAssertFalse(selector.matches(date: .dayMonthYear(10, .february, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(24, .february, 2019), options: options))
    }

    // MARK: - RecurrenceSelector Stack
    func testRecurrenceSelectorStackMatches() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.april, .august]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(17, .february, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .april, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(30, .april, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(9, .april, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .august, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(20, .december, 2019), options: options))
        
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .april, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(20, .april, 2019), options: options))
        
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .august, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(20, .august, 2019), options: options))
    }
    
    func testRecurrenceSelectorStackFirst() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.april, .august]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(2, .august, 2019), options: options), .dayMonthYear(17, .april, 2019))
    }
    
    func testRecurrenceSelectorStackLast() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.april, .august]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(20, .august, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(20, .august, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(2, .august, 2019), options: options), .dayMonthYear(20, .august, 2019))
    }
    
    func testRecurrenceSelectorStackBeforeAndAfter() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.april, .august]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(8, .february, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(20, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .august, 2019), options: options), .dayMonthYear(20, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(27, .december, 2019), options: options), .dayMonthYear(20, .august, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .april, 2019), options: options), .dayMonthYear(20, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(20, .april, 2019), options: options), .dayMonthYear(17, .august, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .august, 2019), options: options), .dayMonthYear(20, .august, 2019))
        
        XCTAssertNil(selector.date(after: .dayMonthYear(20, .august, 2019), options: options))
        
        
        let selector2 : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.april, .august]),
            RecurrenceDaysInMonthSelector(days: [1, 31])
        ]
        
        XCTAssertEqual(selector2.date(after: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(1, .april, 2019))
    }
    
}

