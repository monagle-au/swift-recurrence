//
//  RecurrenceSelectorTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 30/3/19.
//

import XCTest
@testable import SwiftRecurrence

class RecurrenceSelectorTests: XCTestCase {
    // MARK: - RecurrenceDaysInWeekSelector
    
    func testRecurrenceDaysInWeekSelectorMatches() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.Monday, .Wednesday, .Friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(30, .December, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(31, .December, 2018), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .January, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(2, .January, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(3, .January, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(4, .January, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .January, 2019), options: options))
    }
    
    func testRecurrenceDaysInWeekSelectorFirst() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.Monday, .Wednesday, .Friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(8, .December, 2019), options: options), .dayMonthYear(9, .December, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(9, .December, 2019), options: options), .dayMonthYear(9, .December, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(12, .December, 2019), options: options), .dayMonthYear(9, .December, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(14, .December, 2019), options: options), .dayMonthYear(9, .December, 2019))
        
        // Test wrapping of years
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .January, 2020), options: options), .dayMonthYear(30, .December, 2019))
    }
    
    func testRecurrenceDaysInWeekSelectorLast() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.Monday, .Wednesday, .Friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(8, .December, 2019), options: options), .dayMonthYear(13, .December, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(9, .December, 2019), options: options), .dayMonthYear(13, .December, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(12, .December, 2019), options: options), .dayMonthYear(13, .December, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(14, .December, 2019), options: options), .dayMonthYear(13, .December, 2019))
        
        // Test wrapping of years
        let tuesdays = RecurrenceDaysInWeekSelector(daysOfWeek: [.Tuesday])
        XCTAssertEqual(tuesdays.last(for: .dayMonthYear(1, .January, 2020), options: options), .dayMonthYear(31, .December, 2019))
    }
    
    func testRecurrenceDaysInWeekSelectorBeforeAndAfter() {
        let selector = RecurrenceDaysInWeekSelector(daysOfWeek: [.Tuesday, .Thursday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .April, 2019), options: options))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(2, .April, 2019))
        XCTAssertNil(selector.date(before: .dayMonthYear(2, .April, 2019), options: options))
        XCTAssertEqual(selector.date(after: .dayMonthYear(2, .April, 2019), options: options), .dayMonthYear(4, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(3, .April, 2019), options: options), .dayMonthYear(2, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(3, .April, 2019), options: options), .dayMonthYear(4, .April, 2019))
        XCTAssertNil(selector.date(after: .dayMonthYear(4, .April, 2019), options: options))
    }
    
    // MARK: - RecurrenceMonthsInYearSelector

    func testRecurrenceMonthsInYearSelectorMatches() {
        let selector = RecurrenceMonthsInYearSelector(months: [.March, .April, .December])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .January, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(25, .March, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .April, 2018), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(18, .June, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(1, .December, 2018), options: options))
    }
    
    func testRecurrenceMonthsInYearSelectorFirst() {
        let selector = RecurrenceMonthsInYearSelector(months: [.March, .April, .December])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(7, .April, 2019), options: options), .dayMonthYear(1, .March, 2019))
    }
    
    func testRecurrenceMonthsInYearSelectorLast() {
        let selector = RecurrenceMonthsInYearSelector(months: [.March, .April, .December])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .April, 2019), options: options), .dayMonthYear(31, .December, 2019))
    }
    
    func testRecurrenceMonthsInYearSelectorBeforeAndAfter() {
        let selector = RecurrenceMonthsInYearSelector(months: [.March, .April, .November])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .February, 2019), options: options)) // Outside
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .March, 2019), options: options))     // On
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .March, 2019), options: options))    // Inside
        
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(1, .March, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .May, 2019), options: options), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(1, .December, 2019), options: options), .dayMonthYear(1, .November, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(10, .February, 2019), options: options), .dayMonthYear(1, .March, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .March, 2019), options: options), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(10, .March, 2019), options: options), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(1, .November, 2019))
        
        XCTAssertNil(selector.date(after: .dayMonthYear(10, .November, 2019), options: options)) // Inside
        XCTAssertNil(selector.date(after: .dayMonthYear(30, .November, 2019), options: options)) // On
        XCTAssertNil(selector.date(after: .dayMonthYear(1, .December, 2019), options: options))  // Outside
    }
    
    // MARK: - RecurrenceDaysInMonthSelector

    func testRecurrenceDaysInMonthSelectorMatches() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(5, .December, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .December, 2018), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(31, .December, 2018), options: options))
    }
    
    func testRecurrenceDaysInMonthSelectorFirst() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 19, 30, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(7, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
    }
    
    func testRecurrenceDaysInMonthSelectorLast() {
        let selector = RecurrenceDaysInMonthSelector(days: [17, 19, 30, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .April, 2019), options: options), .dayMonthYear(30, .April, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(7, .February, 2019), options: options), .dayMonthYear(19, .February, 2019))
    }
    
    func testRecurrenceDaysInMonthSelectorMatchesBeforeAndAfter() {
        let selector = RecurrenceDaysInMonthSelector(days: [2, 12, 17, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(1, .April, 2019), options: options))
        XCTAssertNil(selector.date(before: .dayMonthYear(2, .April, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(15, .April, 2019), options: options), .dayMonthYear(12, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .April, 2019), options: options), .dayMonthYear(12, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(2, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(2, .April, 2019), options: options), .dayMonthYear(12, .April, 2019))
        XCTAssertNil(selector.date(after: .dayMonthYear(17, .April, 2019), options: options))
    }
    
    // MARK: - RecurrenceOrdinalDaysInMonthSelector
    func testOrdinalRangeOfDays() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))

        do {
            let range = RecurrenceMonthlyOrdinal.first.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 1)
            XCTAssertEqual(range?.last, 7)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.second.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 8)
            XCTAssertEqual(range?.last, 14)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.third.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 15)
            XCTAssertEqual(range?.last, 21)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.fourth.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 22)
            XCTAssertEqual(range?.last, 28)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.fifth.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 29)
            XCTAssertEqual(range?.last, 30)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.fifth.daysOfMonth(for: .dayMonthYear(1, .February, 2019), options: options)
            XCTAssertNil(range)
        }

        do {
            let range = RecurrenceMonthlyOrdinal.last.daysOfMonth(for: .dayMonthYear(1, .April, 2019), options: options)
            XCTAssertEqual(range?.first, 24)
            XCTAssertEqual(range?.last, 30)
        }
    }
    
    func testRecurrenceOrdinalDaysInMonthSelectorMatchingDayOfMonth() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .first, days: [.Sunday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 7)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .second, days: [.Tuesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 9)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .third, days: [.Friday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 19)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fourth, days: [.Monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 22)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.Monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 29)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.Friday, .Thursday, .Wednesday, .Monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 29)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.Friday, .Thursday, .Wednesday, .Tuesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 30)
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .fifth, days: [.Friday])
            XCTAssertNil(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options))
        }
        
        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.Monday, .Tuesday, .Wednesday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 30)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 30)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.Monday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .April, 2019), options: options), 29)
        }

        do {
            let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.Sunday])
            XCTAssertEqual(selector.matchingDayOfMonth(for: .dayMonthYear(1, .August, 2019), options: options), 25)
        }

    }

    func testRecurrenceOrdinalDaysInMonthSelectorMatches() {
        let selector = RecurrenceOrdinalDaysInMonthSelector(ordinal: .last, days: [.Sunday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(20, .January, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(27, .January, 2019), options: options))

        XCTAssertFalse(selector.matches(date: .dayMonthYear(10, .February, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(24, .February, 2019), options: options))
    }

    // MARK: - RecurrenceSelector Stack
    func testRecurrenceSelectorStackMatches() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.April, .August]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertFalse(selector.matches(date: .dayMonthYear(17, .February, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .April, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(30, .April, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(9, .April, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(1, .August, 2019), options: options))
        XCTAssertFalse(selector.matches(date: .dayMonthYear(20, .December, 2019), options: options))
        
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .April, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(20, .April, 2019), options: options))
        
        XCTAssertTrue(selector.matches(date: .dayMonthYear(17, .August, 2019), options: options))
        XCTAssertTrue(selector.matches(date: .dayMonthYear(20, .August, 2019), options: options))
    }
    
    func testRecurrenceSelectorStackFirst() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.April, .August]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.first(for: .dayMonthYear(2, .August, 2019), options: options), .dayMonthYear(17, .April, 2019))
    }
    
    func testRecurrenceSelectorStackLast() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.April, .August]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertEqual(selector.last(for: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(20, .August, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(20, .August, 2019))
        XCTAssertEqual(selector.last(for: .dayMonthYear(2, .August, 2019), options: options), .dayMonthYear(20, .August, 2019))
    }
    
    func testRecurrenceSelectorStackBeforeAndAfter() {
        let selector : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.April, .August]),
            RecurrenceDaysInMonthSelector(days: [17, 20])
        ]
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2018))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(8, .February, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(20, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .August, 2019), options: options), .dayMonthYear(20, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(27, .December, 2019), options: options), .dayMonthYear(20, .August, 2019))
        
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .April, 2019), options: options), .dayMonthYear(20, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(20, .April, 2019), options: options), .dayMonthYear(17, .August, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .August, 2019), options: options), .dayMonthYear(20, .August, 2019))
        
        XCTAssertNil(selector.date(after: .dayMonthYear(20, .August, 2019), options: options))
        
        
        let selector2 : [Recurrable] = [
            RecurrenceMonthsInYearSelector(months: [.April, .August]),
            RecurrenceDaysInMonthSelector(days: [1, 31])
        ]
        
        XCTAssertEqual(selector2.date(after: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(1, .April, 2019))
    }
    
}

