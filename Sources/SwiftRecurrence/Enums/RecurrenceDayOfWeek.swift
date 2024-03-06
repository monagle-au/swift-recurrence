import Foundation

public enum RecurrenceDayOfWeek : Int, Codable, RawComparable, CaseIterable {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
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
    
    public static var All = Set(RecurrenceDayOfWeek.allCases)
    public static var Weekdays: Set<RecurrenceDayOfWeek> = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
    public static var Weekend: Set<RecurrenceDayOfWeek> = [.Saturday, .Sunday]
    
    public var isWeekday : Bool {
        get { return RecurrenceDayOfWeek.Weekdays.contains(self) }
    }
    
    public var isWeekend : Bool {
        get { return RecurrenceDayOfWeek.Weekend.contains(self) }
    }
    
    public func next() -> RecurrenceDayOfWeek {
        return RecurrenceDayOfWeek(number: self.rawValue + 1)
    }
}

extension Set where Element == RecurrenceDayOfWeek {
    public static var Weekdays = RecurrenceDayOfWeek.Weekdays
    public static var Weekend = RecurrenceDayOfWeek.Weekend
    public static var All = RecurrenceDayOfWeek.All
}
