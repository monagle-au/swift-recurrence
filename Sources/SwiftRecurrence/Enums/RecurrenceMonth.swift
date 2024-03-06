import Foundation

public enum RecurrenceMonth : Int, Codable, RawComparable, CaseIterable {
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
}

extension RecurrenceMonth {
    public init(from date: Date, calendar: Calendar = Calendar.current) {
        let month = calendar.component(.month, from: date)
        self.init(rawValue: month)!
    }
    
    public func numberOfDays(year: Int, calendar: Calendar = Calendar.current) -> Int {
        let components = DateComponents(year: year, month: self.rawValue)
        let date = calendar.date(from: components)
        return calendar.daysInMonth(of: date!)
    }
}
