import Foundation

public enum RecurrenceMonth : Int, Codable, RawComparable, Sendable, CaseIterable  {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension RecurrenceMonth {
    public init(from date: Date, calendar: Calendar = Calendar.current) {
        let month = calendar.component(.month, from: date)
        self.init(rawValue: month)!
    }
    
    public func name(calendar: Calendar = Calendar.current) -> String {
        calendar.monthSymbols[self.rawValue - 1]
        }
    
    public func numberOfDays(year: Int, calendar: Calendar = Calendar.current) -> Int {
        let components = DateComponents(year: year, month: self.rawValue)
        let date = calendar.date(from: components)!
        return calendar.daysInMonth(of: date)
    }
}
