import Foundation

public enum RecurrenceDayOfWeek : Int, Sendable, Codable, RawComparable, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension RecurrenceDayOfWeek {
    public init(number: Int) {
        var adjusted = number.remainderReportingOverflow(dividingBy: 7).partialValue
        if adjusted < 1 { adjusted = 7 + adjusted }
        self = RecurrenceDayOfWeek(rawValue: adjusted)!
    }
    
    public init(from date: Date, calendar: Calendar = Calendar.current) {
        let day = calendar.component(.weekday, from: date)
        self.init(rawValue: day)!
    }

    public static func only(_ days : RecurrenceDayOfWeek ...) -> Set<RecurrenceDayOfWeek> {
        return Set<RecurrenceDayOfWeek>(days)
    }
    
    public static let all = Set(RecurrenceDayOfWeek.allCases)
    public static let weekdays: Set<RecurrenceDayOfWeek> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    public static let weekend: Set<RecurrenceDayOfWeek> = [.saturday, .sunday]
    
    public var isWeekday : Bool {
        get { return RecurrenceDayOfWeek.weekdays.contains(self) }
    }
    
    public var isWeekend : Bool {
        get { return RecurrenceDayOfWeek.weekend.contains(self) }
    }
    
    public func next() -> RecurrenceDayOfWeek {
        return RecurrenceDayOfWeek(number: self.rawValue + 1)
    }
}

extension Set where Element == RecurrenceDayOfWeek {
    public static let weekdays = RecurrenceDayOfWeek.weekdays
    public static let weekend = RecurrenceDayOfWeek.weekend
    public static let all = RecurrenceDayOfWeek.all
}
