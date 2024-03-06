import XCTest
@testable import SwiftRecurrence

final class RecurrenceRuleTests: XCTestCase {
    func testDaily() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(31, .March, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 1).date(before: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(31, .March, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 1).date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(2, .April, 2019))

        XCTAssertEqual(RecurrenceRule.daily(every: 4).date(before: .dayMonthYear(6, .April, 2019), options: options), .dayMonthYear(4, .April, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 4).date(after: .dayMonthYear(6, .April, 2019), options: options), .dayMonthYear(8, .April, 2019))
    }

    func testWeekly() {
        let weekly : RecurrenceRule = .weekly(every: 1, days: [.Friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))

        XCTAssertEqual(weekly.first(options: options), .dayMonthYear(4, .January, 2019))
        XCTAssertEqual(weekly.date(after: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(4, .January, 2019))
        XCTAssertEqual(weekly.date(after: .dayMonthYear(4, .January, 2019), options: options), .dayMonthYear(11, .January, 2019))
    }
    
    func testFortnightly() {
        let fortnightly : RecurrenceRule = .weekly(every: 2, days: [.Tuesday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(19, .February, 2019))

        XCTAssertEqual(fortnightly.first(options: options), .dayMonthYear(19, .February, 2019))
        XCTAssertEqual(fortnightly.date(after: .dayMonthYear(19, .February, 2019), options: options), .dayMonthYear(5, .March, 2019))
        XCTAssertEqual(fortnightly.date(after: .dayMonthYear(5, .March, 2019), options: options), .dayMonthYear(19, .March, 2019))
    }
    
    func testMonthly() {
        let rule = RecurrenceRule.monthly(every: 3, days: [1, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(2, .January, 2019))
        
        XCTAssertEqual(rule.date(after: .dayMonthYear(31, .January, 2019), options: options), .dayMonthYear(1, .April, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(1, .July, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(1, .July, 2019), options: options), .dayMonthYear(31, .July, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(31, .July, 2019), options: options), .dayMonthYear(1, .October, 2019))

        XCTAssertEqual(rule.date(before: .dayMonthYear(17, .April, 2019), options: options), .dayMonthYear(1, .April, 2019))
    }
    
    func testEndDateIsStillWithinContext() {
        let rule = RecurrenceRule.monthly(every: 1, days: [1])
        let options = RecurrenceOptions(startDate: .dayMonthYear(2, .January, 2019), endDate: .dayMonthYear(17, .April, 2019))
        
        XCTAssertEqual(rule.date(before: .dayMonthYear(17, .April, 2019), options: options), .dayMonthYear(1, .April, 2019))
    }
    
    func testYearly() {
        let selector = RecurrenceRule.annually(every: 2, in: [.April, .August], days: [17, 20])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .January, 2019))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .April, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .April, 2020), options: options), .dayMonthYear(20, .August, 2019))

        XCTAssertEqual(selector.date(before: .dayMonthYear(20, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .August, 2019), options: options), .dayMonthYear(20, .April, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(27, .December, 2019), options: options), .dayMonthYear(20, .August, 2019))

        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .January, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .April, 2019), options: options), .dayMonthYear(17, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .April, 2019), options: options), .dayMonthYear(20, .April, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(20, .April, 2019), options: options), .dayMonthYear(17, .August, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .August, 2019), options: options), .dayMonthYear(20, .August, 2019))
    }
}
