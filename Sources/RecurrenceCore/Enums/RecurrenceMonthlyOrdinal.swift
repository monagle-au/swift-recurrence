import Foundation

public enum RecurrenceMonthlyOrdinal : Int, Codable, Sendable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case last = -1
}
