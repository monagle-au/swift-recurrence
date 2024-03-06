//
//  RecurrenceIntervalTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 29/3/19.
//

import XCTest
@testable import SwiftRecurrence

class RecurrenceIntervalTests: XCTestCase {
    func testDailyIntervalFirst() {
        XCTAssertEqual(1.recurringDays.first(for: .dayMonthYear(1, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(2.recurringDays.first(for: .dayMonthYear(2, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(5.recurringDays.first(for: .dayMonthYear(10, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(6, .April, 2019))
        XCTAssertEqual(5.recurringDays.first(for: .dayMonthYear(9, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(31, .March, 2019))), .dayMonthYear(5, .April, 2019))
    }
    
    func testWeeklyIntervalFirst() {
        XCTAssertEqual(1.recurringWeeks.first(for: .dayMonthYear(5, .May, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(5, .May, 2019))
        XCTAssertEqual(2.recurringWeeks.first(for: .dayMonthYear(2, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(10, .February, 2019))), .dayMonthYear(24, .March, 2019))
        XCTAssertEqual(5.recurringWeeks.first(for: .dayMonthYear(10, .December, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(1, .December, 2019))
    }
    
    func testMonthlyIntervalFirst() {
        XCTAssertEqual(1.recurringMonths.first(for: .dayMonthYear(5, .May, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(1, .May, 2019))
        XCTAssertEqual(2.recurringMonths.first(for: .dayMonthYear(2, .April, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(10, .February, 2019))), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(5.recurringMonths.first(for: .dayMonthYear(10, .December, 2019), options: RecurrenceOptions(startDate: .dayMonthYear(1, .April, 2019))), .dayMonthYear(1, .September, 2019))
    }
    
    func testSelectorFirstAndLast() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))
        let twoYears = 2.recurringYears

        XCTAssertEqual(twoYears.first(for: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(1, .January, 2019))
        XCTAssertEqual(twoYears.last(for: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(31, .December, 2019))

        let twoWeeks = 2.recurringWeeks
        XCTAssertEqual(twoWeeks.first(for: .dayMonthYear(9, .January, 2019), options: options), .dayMonthYear(30, .December, 2018))
        XCTAssertEqual(twoWeeks.last(for: .dayMonthYear(9, .January, 2019), options: options), .dayMonthYear(5, .January, 2019))
    }
    
    func testEquatable() {
        XCTAssertEqual(1.recurringDays, 1.recurringDays)
        XCTAssertEqual(4.recurringYears, 4.recurringYears)
        XCTAssertNotEqual(2.recurringMonths, 2.recurringDays)
        XCTAssertNotEqual(3.recurringDays, 2.recurringDays)
    }
}
