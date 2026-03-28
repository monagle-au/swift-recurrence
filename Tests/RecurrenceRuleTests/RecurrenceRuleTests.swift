//
//  RecurrenceRuleTests.swift
//  swift-recurrence
//
//  Created by David Monagle on 8/10/2025.
//

import XCTest
@testable import RecurrenceRule

final class RecurrenceRuleTests: XCTestCase {
    func testDailyFactory() {
        let rule = RecurrenceRule.daily(interval: 3)
        XCTAssertEqual(rule.interval, 3)
        if case .daily = rule.frequency {} else {
            XCTFail("Expected daily frequency")
        }
    }
}
