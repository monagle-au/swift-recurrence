//
//  RecurrenceRule+ProtoTests.swift
//  recurrence-swift
//
//  Created by David Monagle on 28/3/2026.
//

import XCTest
@testable import RecurrenceProtobuf
import RecurrenceRule

final class RecurrenceRuleProtoTests: XCTestCase {
    let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

    private func roundTrip(_ rule: RecurrenceRule, file: StaticString = #filePath, line: UInt = #line) throws {
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        let decoded = try RecurrenceRule(proto: proto)
        XCTAssertEqual(decoded.interval, rule.interval, file: file, line: line)
        XCTAssertEqual(decoded.start.timeIntervalSinceReferenceDate, rule.start.timeIntervalSinceReferenceDate, accuracy: 0.001, file: file, line: line)
    }

    // MARK: - Daily

    func testDailyRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 3,
            frequency: .daily(.init()),
            start: referenceDate,
            end: .never
        )
        try roundTrip(rule)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        XCTAssertEqual(proto.interval, 3)
        if case .daily = proto.frequency {} else {
            XCTFail("Expected daily frequency")
        }
        XCTAssertNil(proto.end)
    }

    // MARK: - Weekly

    func testWeeklyRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .weekly(.init(weekDays: [.monday, .wednesday, .friday])),
            start: referenceDate,
            end: .occurrences(10)
        )
        try roundTrip(rule)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .weekly(let w) = proto.frequency {
            let weekdays = Set(w.weekdays)
            XCTAssertEqual(weekdays, [.monday, .wednesday, .friday])
        } else {
            XCTFail("Expected weekly frequency")
        }
        if case .endOccurrences(let count) = proto.end {
            XCTAssertEqual(count, 10)
        } else {
            XCTFail("Expected endOccurrences")
        }
        // Verify round trip preserves weekdays
        let decoded = try RecurrenceRule(proto: proto)
        if case .weekly(let weekly) = decoded.frequency {
            XCTAssertEqual(weekly.weekDays, [.monday, .wednesday, .friday])
        } else {
            XCTFail("Expected weekly frequency after round trip")
        }
    }

    // MARK: - Monthly (every)

    func testMonthlyEveryRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .every(daysOfMonth: [1, 15]))),
            start: referenceDate,
            end: .never
        )
        try roundTrip(rule)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .monthly(let m) = proto.frequency,
           case .every(let every)? = m.days.selection {
            XCTAssertEqual(Set(every.daysOfMonth), [1, 15])
        } else {
            XCTFail("Expected monthly every frequency")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .monthly(let monthly) = decoded.frequency,
           case .every(let days) = monthly.days {
            XCTAssertEqual(days, [1, 15])
        } else {
            XCTFail("Expected monthly every after round trip")
        }
    }

    // MARK: - Monthly (ordinal)

    func testMonthlyOrdinalRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .second, weekDays: [.tuesday]))),
            start: referenceDate,
            end: .never
        )
        try roundTrip(rule)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .monthly(let m) = proto.frequency,
           case .onThe(let onThe)? = m.days.selection {
            XCTAssertEqual(onThe.ordinal, .second)
            XCTAssertEqual(Set(onThe.weekdays), [.tuesday])
        } else {
            XCTFail("Expected monthly ordinal frequency")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .monthly(let monthly) = decoded.frequency,
           case .onThe(let ordinal, let weekDays) = monthly.days {
            XCTAssertEqual(ordinal, .second)
            XCTAssertEqual(weekDays, [.tuesday])
        } else {
            XCTFail("Expected monthly ordinal after round trip")
        }
    }

    func testMonthlySecondLastRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .secondLast, weekDays: [.friday]))),
            start: referenceDate,
            end: .never
        )
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .monthly(let m) = proto.frequency,
           case .onThe(let onThe)? = m.days.selection {
            XCTAssertEqual(onThe.ordinal, .secondLast)
        } else {
            XCTFail("Expected monthly ordinal frequency")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .monthly(let monthly) = decoded.frequency,
           case .onThe(let ordinal, _) = monthly.days {
            XCTAssertEqual(ordinal, .secondLast)
        } else {
            XCTFail("Expected secondLast ordinal after round trip")
        }
    }

    func testMonthlyLastRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .monthly(.init(days: .onThe(ordinal: .last, weekDays: [.sunday]))),
            start: referenceDate,
            end: .never
        )
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .monthly(let m) = proto.frequency,
           case .onThe(let onThe)? = m.days.selection {
            XCTAssertEqual(onThe.ordinal, .last)
        } else {
            XCTFail("Expected monthly ordinal frequency")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .monthly(let monthly) = decoded.frequency,
           case .onThe(let ordinal, _) = monthly.days {
            XCTAssertEqual(ordinal, .last)
        } else {
            XCTFail("Expected last ordinal after round trip")
        }
    }

    // MARK: - Annually (every)

    func testAnnuallyEveryRoundTrip() throws {
        let endDate = Date(timeIntervalSinceReferenceDate: 86400 * 365 * 5)
        let rule = RecurrenceRule(
            interval: 1,
            frequency: .annually(.init(months: [.january, .july], days: .every(daysOfMonth: [1]))),
            start: referenceDate,
            end: .date(endDate)
        )
        try roundTrip(rule)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .annually(let a) = proto.frequency {
            XCTAssertEqual(Set(a.months), [.january, .july])
            if case .every(let every)? = a.days.selection {
                XCTAssertEqual(every.daysOfMonth, [1])
            } else {
                XCTFail("Expected every days selection")
            }
        } else {
            XCTFail("Expected annually frequency")
        }
        if case .endDate(let ts) = proto.end {
            XCTAssertEqual(ts.date.timeIntervalSinceReferenceDate, endDate.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("Expected endDate")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .annually(let annually) = decoded.frequency {
            XCTAssertEqual(annually.months, [.january, .july])
        } else {
            XCTFail("Expected annually frequency after round trip")
        }
    }

    // MARK: - Annually (ordinal)

    func testAnnuallyOrdinalRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .annually(.init(months: [.march, .september], days: .onThe(ordinal: .last, weekDays: [.friday]))),
            start: referenceDate,
            end: .never
        )
        try roundTrip(rule)
        let decoded = try RecurrenceRule(proto: RecurrenceProtoV1RecurrenceRule(rule))
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
            XCTFail("Expected annually frequency after round trip")
        }
    }

    // MARK: - End conditions

    func testEndNever() throws {
        let rule = RecurrenceRule(interval: 1, frequency: .daily(.init()), start: referenceDate, end: .never)
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        XCTAssertNil(proto.end)
        let decoded = try RecurrenceRule(proto: proto)
        if case .never = decoded.end {} else {
            XCTFail("Expected never end")
        }
    }

    func testEndDate() throws {
        let endDate = Date(timeIntervalSinceReferenceDate: 86400 * 30)
        let rule = RecurrenceRule(interval: 1, frequency: .daily(.init()), start: referenceDate, end: .date(endDate))
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .endDate = proto.end {} else {
            XCTFail("Expected endDate")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .date(let date) = decoded.end {
            XCTAssertEqual(date.timeIntervalSinceReferenceDate, endDate.timeIntervalSinceReferenceDate, accuracy: 0.001)
        } else {
            XCTFail("Expected date end")
        }
    }

    func testEndOccurrences() throws {
        let rule = RecurrenceRule(interval: 1, frequency: .daily(.init()), start: referenceDate, end: .occurrences(42))
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        if case .endOccurrences(let count) = proto.end {
            XCTAssertEqual(count, 42)
        } else {
            XCTFail("Expected endOccurrences")
        }
        let decoded = try RecurrenceRule(proto: proto)
        if case .occurrences(let count) = decoded.end {
            XCTAssertEqual(count, 42)
        } else {
            XCTFail("Expected occurrences end")
        }
    }

    // MARK: - Error cases

    func testMissingFrequencyThrows() {
        let proto = RecurrenceProtoV1RecurrenceRule()
        XCTAssertThrowsError(try RecurrenceRule(proto: proto)) { error in
            if case RecurrenceProtoV1Error.missingFrequency = error {} else {
                XCTFail("Expected missingFrequency error, got \(error)")
            }
        }
    }

    // MARK: - Protobuf binary round trip

    func testProtobufBinaryRoundTrip() throws {
        let rule = RecurrenceRule(
            interval: 2,
            frequency: .annually(.init(months: [.march, .september], days: .onThe(ordinal: .third, weekDays: [.monday, .friday]))),
            start: referenceDate,
            end: .occurrences(24)
        )
        let proto = RecurrenceProtoV1RecurrenceRule(rule)
        let data = try proto.serializedData()
        let deserialized = try RecurrenceProtoV1RecurrenceRule(serializedData: data)
        let decoded = try RecurrenceRule(proto: deserialized)
        XCTAssertEqual(decoded.interval, 2)
        if case .annually(let annually) = decoded.frequency {
            XCTAssertEqual(annually.months, Set<RecurrenceMonth>([.march, .september]))
            if case .onThe(let ordinal, let weekDays) = annually.days {
                XCTAssertEqual(ordinal, RecurrenceMonthlyOrdinal.third)
                XCTAssertEqual(weekDays, Set<Locale.Weekday>([.monday, .friday]))
            } else {
                XCTFail("Expected onThe days")
            }
        } else {
            XCTFail("Expected annually frequency")
        }
        if case .occurrences(let count) = decoded.end {
            XCTAssertEqual(count, 24)
        } else {
            XCTFail("Expected occurrences end")
        }
    }
}
