//
//  Calendar+HelpersTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 29/3/19.
//

import XCTest
@testable import SwiftRecurrence

class Calendar_HelpersTests: XCTestCase {
    func testDatesAreWithinSameWeek() {
        let calendar = Calendar.current
        XCTAssertTrue(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .December, 2023), .dayMonthYear(3, .January, 2024)))
        XCTAssertTrue(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .December, 2023), .dayMonthYear(6, .January, 2024)))
        XCTAssertFalse(calendar.datesAreWithinSameWeek(.dayMonthYear(31, .December, 2023), .dayMonthYear(7, .January, 2024)))
    }
}
