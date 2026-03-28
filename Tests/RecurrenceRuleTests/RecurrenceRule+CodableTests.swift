//
//  RecurrenceRule+CodableTests.swift
//  swift-recurrence
//
//  Created by David Monagle on 28/3/2026.
//

import XCTest
@testable import RecurrenceRule

final class RecurrenceRuleCodableTests: XCTestCase {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    private func roundTrip(_ rule: RecurrenceRule, file: StaticString = #filePath, line: UInt = #line) throws {
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        // Compare fields individually since Date equality can be tricky
        XCTAssertEqual(decoded.interval, rule.interval, file: file, line: line)
        XCTAssertEqual(decoded.start.timeIntervalSinceReferenceDate, rule.start.timeIntervalSinceReferenceDate, accuracy: 0.001, file: file, line: line)
    }

    func testDailyCodable() throws {
        let rule = RecurrenceRule(
            interval: 3,
            frequency: .daily(.init()),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .never
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        XCTAssertEqual(decoded.interval, 3)
        if case .daily = decoded.frequency {} else {
            XCTFail("Expected daily frequency")
        }
        if case .never = decoded.end {} else {
            XCTFail("Expected never end")
        }
    }

    func testWeeklyCodable() throws {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .weekly(.init(weekDays: [.monday, .wednesday, .friday])),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .occurrences(10)
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        XCTAssertEqual(decoded.interval, 2)
        if case .weekly(let weekly) = decoded.frequency {
            XCTAssertEqual(weekly.weekDays, [.monday, .wednesday, .friday])
        } else {
            XCTFail("Expected weekly frequency")
        }
        if case .occurrences(let count) = decoded.end {
            XCTAssertEqual(count, 10)
        } else {
            XCTFail("Expected occurrences end")
        }
    }

    func testMonthlyEveryDayCodable() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .every(daysOfMonth: [1, 15]))),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .never
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        if case .monthly(let monthly) = decoded.frequency {
            if case .every(let days) = monthly.days {
                XCTAssertEqual(days, [1, 15])
            } else {
                XCTFail("Expected every days selection")
            }
        } else {
            XCTFail("Expected monthly frequency")
        }
    }

    func testMonthlyOrdinalCodable() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .second, weekDays: [.tuesday]))),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .never
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        if case .monthly(let monthly) = decoded.frequency {
            if case .onThe(let ordinal, let weekDays) = monthly.days {
                XCTAssertEqual(ordinal, .second)
                XCTAssertEqual(weekDays, [.tuesday])
            } else {
                XCTFail("Expected onThe days selection")
            }
        } else {
            XCTFail("Expected monthly frequency")
        }
    }

    func testAnnuallyCodable() throws {
        let endDate = Date(timeIntervalSinceReferenceDate: 86400 * 365 * 5)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.january, .july], days: .every(daysOfMonth: [1]))),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .date(endDate)
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        if case .annually(let annually) = decoded.frequency {
            XCTAssertEqual(annually.months, [.january, .july])
            if case .every(let days) = annually.days {
                XCTAssertEqual(days, [1])
            } else {
                XCTFail("Expected every days selection")
            }
        } else {
            XCTFail("Expected annually frequency")
        }
        if case .date(let date) = decoded.end {
            XCTAssertEqual(date.timeIntervalSinceReferenceDate, endDate.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("Expected date end")
        }
    }

    func testAnnuallyOrdinalCodable() throws {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .annually(.init(months: [.march, .september], days: .onThe(ordinal: .last, weekDays: [.friday]))),
            start: Date(timeIntervalSinceReferenceDate: 0),
            end: .never
        )
        let data = try encoder.encode(rule)
        let decoded = try decoder.decode(RecurrenceRule.self, from: data)
        XCTAssertEqual(decoded.interval, 2)
        if case .annually(let annually) = decoded.frequency {
            XCTAssertEqual(annually.months, [.march, .september])
            if case .onThe(let ordinal, let weekDays) = annually.days {
                XCTAssertEqual(ordinal, .last)
                XCTAssertEqual(weekDays, [.friday])
            } else {
                XCTFail("Expected onThe days selection")
            }
        } else {
            XCTFail("Expected annually frequency")
        }
    }
}
