//
//  RecurrenceRulePeriodTests.swift
//  Recurrence
//
//  Created by David Monagle on 13/3/20.
//  Copyright © 2020 David Monagle. All rights reserved.
//

import XCTest
@testable import SwiftRecurrence

import SwiftRecurrence

class RecurrenceRulePeriodTests: XCTestCase {
    let options = RecurrenceOptions(
        startDate: .dayMonthYear(2, .January, 2020),
        endDate: .dayMonthYear(24, .December, 2020)
    )
    let rule = RecurrenceRule.monthlyOrdinal(every: 1, onThe: .last, .All)

    func testDaysInPeriodAtStartOfContext() {
        XCTAssertNil(rule.firstDayOfPeriod(containing: .dayMonthYear(1, .January, 2020), options: options))
        XCTAssertNil(rule.lastDayOfPeriod(containing: .dayMonthYear(1, .January, 2020), options: options))

        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(2, .January, 2020), options: options), .dayMonthYear(2, .January, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .January, 2020), options: options), .dayMonthYear(2, .January, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .January, 2020), options: options), .dayMonthYear(2, .January, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(2, .January, 2020), options: options), .dayMonthYear(31, .January, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .January, 2020), options: options), .dayMonthYear(31, .January, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .January, 2020), options: options), .dayMonthYear(31, .January, 2020))
        
        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .January, 2020), options: options), 30)
    }

    func testDaysInPeriod() {
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(2, .July, 2020), options: options), .dayMonthYear(1, .July, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .July, 2020), options: options), .dayMonthYear(1, .July, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .July, 2020), options: options), .dayMonthYear(1, .July, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(2, .July, 2020), options: options), .dayMonthYear(31, .July, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .July, 2020), options: options), .dayMonthYear(31, .July, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .July, 2020), options: options), .dayMonthYear(31, .July, 2020))
        
        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .July, 2020), options: options), 31)
    }
    
    func testDaysInPeriodAtEndOfContext() {
        XCTAssertNil(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .December, 2020), options: options))
        XCTAssertNil(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .December, 2020), options: options))

        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(1, .December, 2020), options: options), .dayMonthYear(1, .December, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .December, 2020), options: options), .dayMonthYear(1, .December, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(24, .December, 2020), options: options), .dayMonthYear(1, .December, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(1, .December, 2020), options: options), .dayMonthYear(24, .December, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .December, 2020), options: options), .dayMonthYear(24, .December, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(24, .December, 2020), options: options), .dayMonthYear(24, .December, 2020))

        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .December, 2020), options: options), 24)
    }
}
