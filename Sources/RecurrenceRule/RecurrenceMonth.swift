import Foundation

/// Represents a calendar month, independent of any specific year.
///
/// Raw values map directly to `Calendar.component(.month, from:)` results (1 = January, 12 = December).
/// Conforms to `RawComparable` so months sort in calendar order.
public enum RecurrenceMonth : Int, Codable, RawComparable, Sendable, CaseIterable  {
    /// January (raw value 1).
    case january = 1
    /// February (raw value 2).
    case february
    /// March (raw value 3).
    case march
    /// April (raw value 4).
    case april
    /// May (raw value 5).
    case may
    /// June (raw value 6).
    case june
    /// July (raw value 7).
    case july
    /// August (raw value 8).
    case august
    /// September (raw value 9).
    case september
    /// October (raw value 10).
    case october
    /// November (raw value 11).
    case november
    /// December (raw value 12).
    case december
}

extension RecurrenceMonth {
    /// Initialises a `RecurrenceMonth` from a given date.
    ///
    /// - Parameters:
    ///   - date: The date from which the month component is extracted.
    ///   - calendar: The calendar used to extract the month (default `.current`).
    public init(from date: Date, calendar: Calendar = Calendar.current) {
        let month = calendar.component(.month, from: date)
        self.init(rawValue: month)!
    }

    /// Returns the localised full name of the month for the given calendar.
    ///
    /// - Parameter calendar: The calendar whose month symbols are used (default `.current`).
    /// - Returns: A string such as `"January"` or `"Janvier"` depending on locale.
    public func name(calendar: Calendar = Calendar.current) -> String {
        calendar.monthSymbols[self.rawValue - 1]
        }

    /// Returns the number of days in this month for a given year.
    ///
    /// - Parameters:
    ///   - year: The year used to resolve February's length in leap years.
    ///   - calendar: The calendar to use for the calculation (default `.current`).
    /// - Returns: The number of days (28–31) in the month.
    public func numberOfDays(year: Int, calendar: Calendar = Calendar.current) -> Int {
        let components = DateComponents(year: year, month: self.rawValue)
        let date = calendar.date(from: components)!
        return calendar.daysInMonth(of: date)
    }
}
