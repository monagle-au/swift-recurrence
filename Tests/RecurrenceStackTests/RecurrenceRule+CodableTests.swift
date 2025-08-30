//
//  RecurrenceRule+CodableTests.swift
//  RecurrenceTests
//
//  Created by David Monagle on 29/3/19.
//

import XCTest
@testable import RecurrenceStack

class RecurrenceRule_CodableTests: XCTestCase {
    func testCodableDaily() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.daily(every: 5)
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.daily(interval) = decoded else {
            XCTFail("Expected .daily, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 5)
    }
    
    func testCodableWeekly() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.weekly(every: 2, days: [.monday, .friday])
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.weekly(interval, days) = decoded else {
            XCTFail("Expected .weekly, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 2)
        XCTAssertEqual(days, [.monday, .friday])
    }
    
    func testCodableMonthlyDays() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.monthly(every: 3, days: [3,25])
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.monthly(interval, days) = decoded else {
            XCTFail("Expected .monthly, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 3)
        XCTAssertEqual(days, [3,25])
    }
    
    func testCodableMonthlyOrdinal() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.monthlyOrdinal(every: 4, onThe: .second, [.saturday])
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.monthlyOrdinal(interval, onThe, days) = decoded else {
            XCTFail("Expected .monthlyOrdinal, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 4)
        XCTAssertEqual(onThe, .second)
        XCTAssertEqual(days, [.saturday])
    }
    
    func testCodableAnnually() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.annually(every: 3, in: [.june, .october], days: [3, 8])
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.annually(interval, months, days) = decoded else {
            XCTFail("Expected .annually, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 3)
        XCTAssertEqual(months, [.june, .october])
        XCTAssertEqual(days, [3, 8])
    }
    
    func testCodableAnnuallyOrdinal() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let recurrence = RecurrenceRule.annuallyOrdinal(every: 5, in: [.april, .december], onThe: .last, [.friday])
        let encoded = try! encoder.encode(recurrence)
        let decoded = try! decoder.decode(RecurrenceRule.self, from: encoded)
        guard case let RecurrenceRule.annuallyOrdinal(interval, months, onThe, days) = decoded else {
            XCTFail("Expected .annually, got \(decoded))")
            return
        }
        XCTAssertEqual(interval, 5)
        XCTAssertEqual(months, [.april, .december])
        XCTAssertEqual(onThe, .last)
        XCTAssertEqual(days, [.friday])
    }
}
