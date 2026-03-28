import Foundation

public enum RecurrenceMonthlyOrdinal : Int, Codable, Sendable, CaseIterable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case secondLast = -2
    case last = -1
}
