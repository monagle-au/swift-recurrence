import XCTest
@testable import RecurrenceStack

final class RecurrenceRuleTests: XCTestCase {
    func testDaily() {
        let options = RecurrenceOptions(startDate: .dayMonthYear(31, .march, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 1).date(before: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(31, .march, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 1).date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(2, .april, 2019))

        XCTAssertEqual(RecurrenceRule.daily(every: 4).date(before: .dayMonthYear(6, .april, 2019), options: options), .dayMonthYear(4, .april, 2019))
        XCTAssertEqual(RecurrenceRule.daily(every: 4).date(after: .dayMonthYear(6, .april, 2019), options: options), .dayMonthYear(8, .april, 2019))
    }

    func testWeekly() {
        let weekly : RecurrenceRule = .weekly(every: 1, days: [.friday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2019))

        XCTAssertEqual(weekly.first(options: options), .dayMonthYear(4, .january, 2019))
        XCTAssertEqual(weekly.date(after: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(4, .january, 2019))
        XCTAssertEqual(weekly.date(after: .dayMonthYear(4, .january, 2019), options: options), .dayMonthYear(11, .january, 2019))
    }
    
    func testFortnightly() {
        let fortnightly : RecurrenceRule = .weekly(every: 2, days: [.tuesday])
        let options = RecurrenceOptions(startDate: .dayMonthYear(19, .february, 2019))

        XCTAssertEqual(fortnightly.first(options: options), .dayMonthYear(19, .february, 2019))
        XCTAssertEqual(fortnightly.date(after: .dayMonthYear(19, .february, 2019), options: options), .dayMonthYear(5, .march, 2019))
        XCTAssertEqual(fortnightly.date(after: .dayMonthYear(5, .march, 2019), options: options), .dayMonthYear(19, .march, 2019))
    }
    
    func testMonthly() {
        let rule = RecurrenceRule.monthly(every: 3, days: [1, 31])
        let options = RecurrenceOptions(startDate: .dayMonthYear(2, .january, 2019))
        
        XCTAssertEqual(rule.date(after: .dayMonthYear(31, .january, 2019), options: options), .dayMonthYear(1, .april, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(1, .july, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(1, .july, 2019), options: options), .dayMonthYear(31, .july, 2019))
        XCTAssertEqual(rule.date(after: .dayMonthYear(31, .july, 2019), options: options), .dayMonthYear(1, .october, 2019))

        XCTAssertEqual(rule.date(before: .dayMonthYear(17, .april, 2019), options: options), .dayMonthYear(1, .april, 2019))
    }
    
    func testEndDateIsStillWithinContext() {
        let rule = RecurrenceRule.monthly(every: 1, days: [1])
        let options = RecurrenceOptions(startDate: .dayMonthYear(2, .january, 2019), endDate: .dayMonthYear(17, .april, 2019))
        
        XCTAssertEqual(rule.date(before: .dayMonthYear(17, .april, 2019), options: options), .dayMonthYear(1, .april, 2019))
    }
    
    func testYearly() {
        let selector = RecurrenceRule.annually(every: 2, in: [.april, .august], days: [17, 20])
        let options = RecurrenceOptions(startDate: .dayMonthYear(1, .january, 2019))
        
        XCTAssertNil(selector.date(before: .dayMonthYear(10, .april, 2019), options: options))
        XCTAssertEqual(selector.date(before: .dayMonthYear(18, .april, 2020), options: options), .dayMonthYear(20, .august, 2019))

        XCTAssertEqual(selector.date(before: .dayMonthYear(20, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(17, .august, 2019), options: options), .dayMonthYear(20, .april, 2019))
        XCTAssertEqual(selector.date(before: .dayMonthYear(27, .december, 2019), options: options), .dayMonthYear(20, .august, 2019))

        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .january, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(1, .april, 2019), options: options), .dayMonthYear(17, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .april, 2019), options: options), .dayMonthYear(20, .april, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(20, .april, 2019), options: options), .dayMonthYear(17, .august, 2019))
        XCTAssertEqual(selector.date(after: .dayMonthYear(17, .august, 2019), options: options), .dayMonthYear(20, .august, 2019))
    }
}
