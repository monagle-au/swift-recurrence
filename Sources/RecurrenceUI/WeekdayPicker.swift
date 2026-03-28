//
//  WeekdayPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import Foundation
import SwiftUI
import RecurrenceRule

struct WeekdayPicker: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var weekdaySelection: Set<Locale.Weekday>
    
    private let multiSelect: Bool
    private let mandatory: Bool
    private let locale: Locale

    public init(_ weekdays: Binding<Set<Locale.Weekday>>, multiSelect: Bool = true, mandatory: Bool = false, locale: Locale = .autoupdatingCurrent) {
        self._weekdaySelection = weekdays
        self.multiSelect = multiSelect
        self.mandatory = mandatory
        self.locale = locale
    }
    
    var weekdayOptions: [WeekdayOption] {
        let symbols = (horizontalSizeClass == .compact ? locale.calendar.shortWeekdaySymbols : locale.calendar.weekdaySymbols)
        return Locale.Weekday.all.sorted().map { weekday in
            .init(
                label: Text(symbols[weekday.dayNumber - 1]),
                weekday: weekday
            )
        }
    }
    
    var groupSelection: Binding<WeekdayGroup> {
        .init(
            get: {
                switch weekdaySelection {
                case Set(Locale.Weekday.all): .days
                case Set(Locale.Weekday.weekdays): .weekDays
                case Set(Locale.Weekday.weekend): .weekendDays
                default: .custom
                }
        },
            set: { group in
                switch group {
                case .days: weekdaySelection = Set(Locale.Weekday.all)
                case .weekDays: weekdaySelection = Set(Locale.Weekday.weekdays)
                case .weekendDays: weekdaySelection = Set(Locale.Weekday.weekend)
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
            .background(PlatformColor.systemFill)
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
            .foregroundColor(isSelected ? PlatformColor.systemBackground : .primary)
            .background(isSelected ? Color.accentColor : PlatformColor.secondarySystemBackground)
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
        var id: Int { weekday.dayNumber }
        let label: Text
        let weekday: Locale.Weekday
        var option: some View {
            label.tag(weekday)
        }
        var accessibilityLabel: String {
            "weekdayPickerOption\(weekday.dayNumber)"
        }
    }
}

#Preview {
    @Previewable @State var weekdays: Set<Locale.Weekday> = [.saturday]
    
    Form {
        WeekdayPicker($weekdays, multiSelect: true, mandatory: false)
    }
}

