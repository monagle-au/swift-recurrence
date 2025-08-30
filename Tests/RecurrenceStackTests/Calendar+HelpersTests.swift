//
//  Calendar+HelpersTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 29/3/19.
//

import XCTest
@testable import RecurrenceStack

class Calendar_HelpersTests: XCTestCase {
    func testDatesAreWithinSameWeek() {
        let calendar = Calendar.current
        XCTAssertTrue(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .december, 2023), .dayMonthYear(3, .january, 2024)))
        XCTAssertTrue(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .december, 2023), .dayMonthYear(6, .january, 2024)))
        XCTAssertFalse(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .december, 2023), .dayMonthYear(7, .january, 2024)))
    }
}
