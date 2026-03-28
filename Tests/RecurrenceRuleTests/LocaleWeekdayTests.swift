//
//  LocaleWeekdayTests.swift
//  swift-recurrence
//
//  Created by David Monagle on 20/7/19.
//

import XCTest
@testable import RecurrenceRule

final class LocaleWeekdayTests: XCTestCase {
    func testInitNumber() {
        XCTAssertEqual(Locale.Weekday(dayNumber: 1), .sunday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 2), .monday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 3), .tuesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 4), .wednesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 5), .thursday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 6), .friday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 7), .saturday)

        XCTAssertEqual(Locale.Weekday(dayNumber: 8), .sunday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 9), .monday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 10), .tuesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 11), .wednesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 12), .thursday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 13), .friday)
        XCTAssertEqual(Locale.Weekday(dayNumber: 14), .saturday)

        XCTAssertEqual(Locale.Weekday(dayNumber: 0), .saturday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -1), .friday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -2), .thursday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -3), .wednesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -4), .tuesday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -5), .monday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -6), .sunday)
        XCTAssertEqual(Locale.Weekday(dayNumber: -7), .saturday)
    }

    func testNextDayOfWeek() {
        XCTAssertEqual(Locale.Weekday.sunday.next(), .monday)
        XCTAssertEqual(Locale.Weekday.monday.next(), .tuesday)
        XCTAssertEqual(Locale.Weekday.tuesday.next(), .wednesday)
        XCTAssertEqual(Locale.Weekday.wednesday.next(), .thursday)
        XCTAssertEqual(Locale.Weekday.thursday.next(), .friday)
        XCTAssertEqual(Locale.Weekday.friday.next(), .saturday)
        XCTAssertEqual(Locale.Weekday.saturday.next(), .sunday)
    }
}
