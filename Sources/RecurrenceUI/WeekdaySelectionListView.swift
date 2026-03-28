////
////  WeekdaySelectionListView.swift
////  SwiftUIRecurrenceRule
////
////  Created by David Monagle on 24/2/2025.
////
//
//import SwiftUI
//
//struct WeekdaySelectionListView: View {
//    @State private var addOption: AddOption = .every
//    @State private var weekdaySelection: WeekdaySelection = .sunday
//    
//    @Binding private var weekdays: [Calendar.RecurrenceRule.Weekday]
//    
//    init(selection weekdays: Binding<[Calendar.RecurrenceRule.Weekday]>) {
//        self._weekdays = weekdays
//    }
//    var body: some View {
//        VStack {
//            HStack {
//                addPicker
//                weekdayPicker
//                Spacer()
//                Button("Add") {
//                    for day in weekdaySelection.localeWeekdays {
//                        let option = addOption.recurrenceWeekday(day)
//                        if !weekdays.contains(option) {
//                            weekdays.append(option)
//                        }
//                    }
//                }
//            }
//            .padding()
//            List {
//                ForEach(weekdays, id: \.self) { weekday in
//                    Text(weekday.formattedDescription())
//                }
//                .onDelete(perform: delete)
//            }
//        }
//    }
//    
//    private var addPicker: some View {
//        Picker("Every", selection: $addOption) {
//            ForEach(AddOption.allCases, id: \.self) { option in
//                Text(option.formattedDescription()).tag(option)
//            }
//        }
//    }
//
//    private var weekdayPicker: some View {
//        Picker("Weekday", selection: $weekdaySelection) {
//            ForEach(WeekdaySelection.allCases, id: \.self) { option in
//                Text(option.localizedStringKey).tag(option)
//            }
//        }
//    }
//
//    private func delete(indexSet: IndexSet) {
//        weekdays.remove(atOffsets: indexSet)
//    }
//    
//    private func everyNthWeekdayFormatted(number: Int, weekday: String) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .ordinal // Enables 1st, 2nd, 3rd formatting
//        formatter.locale = Locale.current // Uses the system's language setting
//        
//        let ordinalString = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
//        
//        return String(
//            localized: "Every \(ordinalString) \(weekday)",
//            comment: "Repeating event description with ordinal number and weekday"
//        )
//    }
//}
//
//extension WeekdaySelectionListView {
//    private enum AddOption: Int, CaseIterable {
//        case every = 0
//        case first = 1
//        case second = 2
//        case third = 3
//        case fourth = 4
//        case fifth = 5
//        case last = -1
//        case secondLast = -2
//        
//        func formattedDescription(locale: Locale = .autoupdatingCurrent) -> String {
//            return switch self.rawValue {
//            case 1...:
//                String(localized: "Every \(self.rawValue.formatOrdinal)", comment: "Repeating every nth week")
//            case ..<0:
//                String(localized: "\(self.rawValue.formatOrdinal) last", comment: "Repeating every nth last week")
//            default: // Zero
//                String(localized: "Every", comment: "Repeating every week")
//            }
//        }
//        
//        func recurrenceWeekday(_ day: Locale.Weekday) -> Calendar.RecurrenceRule.Weekday {
//            switch self {
//            case .every:
//                    .every(day)
//            default:
//                    .nth(self.rawValue, day)
//            }
//        }
//    }
//    
//    private enum WeekdaySelection: CaseIterable {
//        case sunday
//        case monday
//        case tuesday
//        case wednesday
//        case thursday
//        case friday
//        case saturday
//        case day
//        case weekday
//        case weekendDay
//        
//        var localizedStringKey: LocalizedStringKey {
//            switch self {
//            case .day: "Day"
//            case .sunday: "Sunday"
//            case .monday: "Monday"
//            case .tuesday: "Tuesday"
//            case .wednesday: "Wednesday"
//            case .thursday: "Thursday"
//            case .friday: "Friday"
//            case .saturday: "Saturday"
//            case .weekday: "Weekday"
//            case .weekendDay: "Weekend Day"
//            }
//        }
//        
//        var localeWeekdays: [Locale.Weekday] {
//            switch self {
//            case .sunday: [.sunday]
//            case .monday: [.monday]
//            case .tuesday: [.tuesday]
//            case .wednesday: [.wednesday]
//            case .thursday: [.thursday]
//            case .friday: [.friday]
//            case .saturday: [.saturday]
//            case .day: [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
//            case .weekday: [.monday, .tuesday, .wednesday, .thursday, .friday]
//            case .weekendDay: [.sunday, .saturday]
//            }
//        }
//    }
//}
//
//
//extension Locale.Weekday {
//    func formattedDescription(locale: Locale = .autoupdatingCurrent) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = locale
//        
//        let index = switch self {
//        case .sunday: 0
//        case .monday: 1
//        case .tuesday: 2
//        case .wednesday: 3
//        case .thursday: 4
//        case .friday: 5
//        case .saturday: 6
//        default: 0
//        }
//        
//        return formatter.weekdaySymbols[index]
//    }
//}
//
//extension Calendar.RecurrenceRule.Weekday {
//    func formattedDescription(locale: Locale = .autoupdatingCurrent) -> String {
//        switch self {
//        case .every(let weekday):
//            return String(localized: "Every \(weekday.formattedDescription(locale: locale))", comment: "Repeating every weekday")
//        case .nth(let nth, let weekday):
//            let numberFormatter = NumberFormatter()
//            numberFormatter.numberStyle = .ordinal
//            numberFormatter.locale = locale
//            
//            guard let ordinalString = numberFormatter.string(from: NSNumber(value: nth)) else {
//                fatalError("Unable to format ordinal string from value: \(nth)")
//            }
//
//            return String(localized: "Every \(ordinalString) \(weekday.formattedDescription(locale: locale))", comment: "Repeating nth weekday")
//        default:
//            fatalError("Unsupported weekday format")
//        }
//    }
//}
//
//private extension Int {
//    var formatOrdinal: String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .ordinal
//        guard let ordinalString = numberFormatter.string(from: NSNumber(value: self)) else {
//            fatalError("Unable to format ordinal string from value: \(self)")
//        }
//        return ordinalString
//    }
//}
//
//extension Calendar.RecurrenceRule.Weekday: @retroactive Hashable {
//    public func hash(into hasher: inout Hasher) {
//        switch self {
//        case .every(let weekday):
//            hasher.combine(weekday)
//        case .nth(let int, let weekday):
//            hasher.combine(int)
//            hasher.combine(weekday)
//        default:
//            break
//        }
//        
//    }
//    
//    // Provide hashValue for platforms/SDKs that still require it for Hashable.
//    // Derive from the same components used in hash(into:) to keep behavior consistent.
//    public var hashValue: Int {
//        switch self {
//        case .every(let weekday):
//            return 0 ^ weekday.hashValue
//        case .nth(let int, let weekday):
//            return int.hashValue ^ weekday.hashValue
//        default:
//            return 0
//        }
//    }
//    
//}
//
//#Preview {
//    @Previewable @State var selectedWeekdays: [Calendar.RecurrenceRule.Weekday] = [.every(.friday), .nth(2, .sunday)]
//    
//    WeekdaySelectionListView(selection: $selectedWeekdays)
//}
