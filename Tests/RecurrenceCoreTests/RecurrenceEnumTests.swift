//
//  RecurrenceEnumTests.swift
//  Recurrence
//
//  Created by David Monagle on 20/7/19.
//

import XCTest
@testable import RecurrenceCore

final class RecurrenceEnumTests: XCTestCase {
    func testInitNumber() {
        XCTAssertEqual(RecurrenceDayOfWeek(number: 1), .sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 2), .monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 3), .tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 4), .wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 5), .thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 6), .friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 7), .saturday)
        
        XCTAssertEqual(RecurrenceDayOfWeek(number: 8), .sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 9), .monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 10), .tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 11), .wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 12), .thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 13), .friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 14), .saturday)
        
        XCTAssertEqual(RecurrenceDayOfWeek(number: 0), .saturday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -1), .friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -2), .thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -3), .wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -4), .tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -5), .monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -6), .sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -7), .saturday)
    }
    
    func testNextDayOfWeek() {
        XCTAssertEqual(RecurrenceDayOfWeek.sunday.next(), .monday)
        XCTAssertEqual(RecurrenceDayOfWeek.monday.next(), .tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek.tuesday.next(), .wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek.wednesday.next(), .thursday)
        XCTAssertEqual(RecurrenceDayOfWeek.thursday.next(), .friday)
        XCTAssertEqual(RecurrenceDayOfWeek.friday.next(), .saturday)
        XCTAssertEqual(RecurrenceDayOfWeek.saturday.next(), .sunday)
    }
}
