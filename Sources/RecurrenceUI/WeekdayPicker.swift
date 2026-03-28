//
//  WeekdayPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import Foundation
import SwiftUI
import RecurrenceCore

struct WeekdayPicker: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var weekdaySelection: Set<RecurrenceDayOfWeek>
    
    private let multiSelect: Bool
    private let mandatory: Bool
    private let locale: Locale

    public init(_ weekdays: Binding<Set<RecurrenceDayOfWeek>>, multiSelect: Bool = true, mandatory: Bool = false, locale: Locale = .autoupdatingCurrent) {
        self._weekdaySelection = weekdays
        self.multiSelect = multiSelect
        self.mandatory = mandatory
        self.locale = locale
    }
    
    var weekdayOptions: [WeekdayOption] {
        let symbols = (horizontalSizeClass == .compact ? locale.calendar.shortWeekdaySymbols : locale.calendar.weekdaySymbols)
        let weekdays = RecurrenceDayOfWeek.all
        return weekdays.enumerated().map { index, value in
            .init(
                label: Text(symbols[index]),
                weekday: value
            )
        }
    }
    
    var groupSelection: Binding<WeekdayGroup> {
        .init(
            get: {
                switch weekdaySelection {
                case Set(RecurrenceDayOfWeek.all): .days
                case Set(RecurrenceDayOfWeek.weekdays): .weekDays
                case Set(RecurrenceDayOfWeek.weekend): .weekendDays
                default: .custom
                }
        },
            set: { group in
                switch group {
                case .days: weekdaySelection = Set(RecurrenceDayOfWeek.all)
                case .weekDays: weekdaySelection = Set(RecurrenceDayOfWeek.weekdays)
                case .weekendDays: weekdaySelection = Set(RecurrenceDayOfWeek.weekend)
                default: break
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 1) {
                ForEach(weekdayOptions) { dayOfWeek in
                    self.cell(dayOfWeek)
                }
            }
            .background(Color(UIColor.systemFill))
            .clipShape(.capsule(style: .continuous))
            if multiSelect {
                Picker("Day of week group", selection: groupSelection) {
                    Text("All").tag(WeekdayGroup.days)
                    Text("Weekdays").tag(WeekdayGroup.weekDays)
                    Text("Weekends").tag(WeekdayGroup.weekendDays)
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    private func cell(_ day: WeekdayOption) -> some View {
        let isSelected = weekdaySelection.contains(day.weekday)
        
        return day.label
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .font(.footnote)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .primary)
            .background(isSelected ? Color.accentColor : Color(UIColor.secondarySystemBackground))
            .accessibility(identifier: day.accessibilityLabel)
            .onTapGesture {
                self.toggle(day)
            }
            .simultaneousGesture(
                TapGesture(count: 2).onEnded { _ in
                    self.weekdaySelection = mandatory ? [day.weekday] : []
                }
            )
    }
    
    private func toggle(_ day: WeekdayOption) {
        let weekday = day.weekday
        if weekdaySelection.contains(weekday), (!mandatory || weekdaySelection.count > 1) {
            weekdaySelection.remove(weekday)
        } else {
            if multiSelect {
                weekdaySelection.insert(weekday)
            } else {
                weekdaySelection = [weekday]
            }
        }
    }
}

extension WeekdayPicker {
    enum WeekdayGroup {
        case custom
        case days
        case weekDays
        case weekendDays
    }
    
    struct WeekdayOption: Identifiable {
        var id: Int { weekday.rawValue }
        let label: Text
        let weekday: RecurrenceDayOfWeek
        var option: some View {
            label.tag(weekday)
        }
        var accessibilityLabel: String {
            "weekdayPickerOption\(weekday.rawValue)"
        }
    }
}

#Preview {
    @Previewable @State var weekdays: Set<RecurrenceDayOfWeek> = [.saturday]
    
    Form {
        WeekdayPicker($weekdays, multiSelect: true, mandatory: false)
    }
}

