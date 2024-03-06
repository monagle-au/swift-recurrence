import Foundation

public enum RecurrenceMonthlyOrdinal : Int, Codable, CaseIterable {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case last
}

extension RecurrenceMonthlyOrdinal {
    public func daysOfMonth(for date: Date, options: RecurrenceOptions) -> (first: Int, last: Int)? {
        let daysInMonth = options.calendar.daysInMonth(of: date)

        switch self {
        case .last:
            return (daysInMonth - 6, daysInMonth)
        default:
            let firstDay = ((self.rawValue - 1) * 7) + 1
            let lastDay = firstDay + 6
            if firstDay > daysInMonth { return nil }
            return (firstDay, lastDay > daysInMonth ? daysInMonth : lastDay)
        }
    }
}
