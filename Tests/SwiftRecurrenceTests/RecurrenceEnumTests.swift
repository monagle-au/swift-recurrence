//
//  RecurrenceEnumTests.swift
//  Recurrence
//
//  Created by David Monagle on 20/7/19.
//

import XCTest
@testable import SwiftRecurrence

final class RecurrenceEnumTests: XCTestCase {
    func testInitNumber() {
        XCTAssertEqual(RecurrenceDayOfWeek(number: 1), .Sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 2), .Monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 3), .Tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 4), .Wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 5), .Thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 6), .Friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 7), .Saturday)
        
        XCTAssertEqual(RecurrenceDayOfWeek(number: 8), .Sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 9), .Monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 10), .Tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 11), .Wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 12), .Thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 13), .Friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: 14), .Saturday)
        
        XCTAssertEqual(RecurrenceDayOfWeek(number: 0), .Saturday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -1), .Friday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -2), .Thursday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -3), .Wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -4), .Tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -5), .Monday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -6), .Sunday)
        XCTAssertEqual(RecurrenceDayOfWeek(number: -7), .Saturday)
    }
    
    func testNextDayOfWeek() {
        XCTAssertEqual(RecurrenceDayOfWeek.Sunday.next(), .Monday)
        XCTAssertEqual(RecurrenceDayOfWeek.Monday.next(), .Tuesday)
        XCTAssertEqual(RecurrenceDayOfWeek.Tuesday.next(), .Wednesday)
        XCTAssertEqual(RecurrenceDayOfWeek.Wednesday.next(), .Thursday)
        XCTAssertEqual(RecurrenceDayOfWeek.Thursday.next(), .Friday)
        XCTAssertEqual(RecurrenceDayOfWeek.Friday.next(), .Saturday)
        XCTAssertEqual(RecurrenceDayOfWeek.Saturday.next(), .Sunday)
    }
}
