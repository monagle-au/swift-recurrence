//
//  RecurrenceRulePeriodTests.swift
//  Recurrence
//
//  Created by David Monagle on 13/3/20.
//  Copyright © 2020 David Monagle. All rights reserved.
//

import XCTest
@testable import RecurrenceStack

import RecurrenceStack

class RecurrenceRulePeriodTests: XCTestCase {
    let options = RecurrenceOptions(
        startDate: .dayMonthYear(2, .january, 2020),
        endDate: .dayMonthYear(24, .december, 2020)
    )
    let rule = RecurrenceRule.monthlyOrdinal(every: 1, onThe: .last, .all)

    func testDaysInPeriodAtStartOfContext() {
        XCTAssertNil(rule.firstDayOfPeriod(containing: .dayMonthYear(1, .january, 2020), options: options))
        XCTAssertNil(rule.lastDayOfPeriod(containing: .dayMonthYear(1, .january, 2020), options: options))

        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(2, .january, 2020), options: options), .dayMonthYear(2, .january, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .january, 2020), options: options), .dayMonthYear(2, .january, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .january, 2020), options: options), .dayMonthYear(2, .january, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(2, .january, 2020), options: options), .dayMonthYear(31, .january, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .january, 2020), options: options), .dayMonthYear(31, .january, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .january, 2020), options: options), .dayMonthYear(31, .january, 2020))
        
        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .january, 2020), options: options), 30)
    }

    func testDaysInPeriod() {
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(2, .july, 2020), options: options), .dayMonthYear(1, .july, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .july, 2020), options: options), .dayMonthYear(1, .july, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .july, 2020), options: options), .dayMonthYear(1, .july, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(2, .july, 2020), options: options), .dayMonthYear(31, .july, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .july, 2020), options: options), .dayMonthYear(31, .july, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .july, 2020), options: options), .dayMonthYear(31, .july, 2020))
        
        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .july, 2020), options: options), 31)
    }
    
    func testDaysInPeriodAtEndOfContext() {
        XCTAssertNil(rule.firstDayOfPeriod(containing: .dayMonthYear(31, .december, 2020), options: options))
        XCTAssertNil(rule.lastDayOfPeriod(containing: .dayMonthYear(31, .december, 2020), options: options))

        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(1, .december, 2020), options: options), .dayMonthYear(1, .december, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(15, .december, 2020), options: options), .dayMonthYear(1, .december, 2020))
        XCTAssertEqual(rule.firstDayOfPeriod(containing: .dayMonthYear(24, .december, 2020), options: options), .dayMonthYear(1, .december, 2020))

        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(1, .december, 2020), options: options), .dayMonthYear(24, .december, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(15, .december, 2020), options: options), .dayMonthYear(24, .december, 2020))
        XCTAssertEqual(rule.lastDayOfPeriod(containing: .dayMonthYear(24, .december, 2020), options: options), .dayMonthYear(24, .december, 2020))

        XCTAssertEqual(rule.daysInPeriod(containing: .dayMonthYear(15, .december, 2020), options: options), 24)
    }
}
