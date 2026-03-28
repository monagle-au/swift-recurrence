import Foundation

public enum RecurrenceOrdinal : Int, Codable, Sendable, CaseIterable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case last = -1
}
