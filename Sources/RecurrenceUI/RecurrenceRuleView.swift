//
//  RecurrenceRuleView.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import Foundation
import SwiftUI
import RecurrenceRule

public struct RecurrenceRuleView: View {
    @Binding var rule: RecurrenceRule
    @State private var recurrence: RecurrenceState

    public init(_ rule: Binding<RecurrenceRule>) {
        self._rule = rule
        self._recurrence = .init(initialValue: RecurrenceState(recurrenceRule: rule.wrappedValue))
    }
    
    public var body: some View {
        Form {
            Section {
                FrequencyPicker($recurrence.frequency)
                IntervalStepper(interval: $recurrence.interval)
                EndRecurrenceView(selection: $recurrence.end)
            }
            switch recurrence.frequency {
            case .weekly:
                Section("Weekly") {
                    WeekdayPicker($recurrence.weekDays)
                }
            case .monthly:
                Section("Monthly") {
                    monthDaySelectionView
                }
            case .yearly:
                Section("Yearly") {
                    MonthSelectionView(selection: $recurrence.months)
                    monthDaySelectionView
                }
            default:
                EmptyView()
            }
        }
        .onChange(of: recurrence) {
            self.rule = recurrence.recurrenceRule
        }
        .toolbar {
            #if os(iOS) || os(visionOS)
            ToolbarItem(placement: .bottomBar) {
                NavigationLink("Preview") {
                    RecurrenceRulePreview(rule.calendarRecurrenceRule(.current))
                }
            }
            #else
            ToolbarItem {
                NavigationLink("Preview") {
                    RecurrenceRulePreview(rule.calendarRecurrenceRule(.current))
                }
            }
            #endif
        }
    }
    
    private var monthDaySelectionView: some View {
        Group {
            MonthDaySelectionPicker(option: $recurrence.monthDaysSelection)
            switch recurrence.monthDaysSelection {
            case .every:
                DaysOfMonthSelectionView(selection: $recurrence.daysOfMonth)
            case .onThe:
                RecurrenceMonthlyOrdinalPicker($recurrence.ordinal)
                WeekdayPicker($recurrence.weekDays)
            }
        }
    }
}

public struct RecurrenceRulePreview: View {
    var rule: Calendar.RecurrenceRule
    @State private var startDate: Date
    @State private var years: Int = 1


    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    init(_ rule: Calendar.RecurrenceRule) {
        self.rule = rule
        self._startDate = .init(initialValue: Date())
    }
    
    var dates: [Date] {
        let startRange = startDate
        let endRange = rule.calendar.date(byAdding: .year, value: years, to: startRange)!
        let recurrences = rule.recurrences(of: startDate, in: startRange..<endRange)
        return Array(recurrences)
    }
    
    public var body: some View {
        VStack {
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                .padding()
            HStack {
                Stepper("Years", value: $years)
                Text("\(years)")
            }
            .padding()
            List(dates, id: \.hashValue) { date in
                Text(Self.dateFormatter.string(from: date))
            }
            DisclosureGroup("Rule") {
                Text(String(describing: rule))
            }
        }
        .navigationTitle("Dates")
    }
}

#Preview {
    @Previewable @State var rule = RecurrenceRule(
        interval: 2,
        frequency: .daily(.init()),
        start: Date(),
        end: .occurrences(5)
    )
    
    NavigationStack {
        RecurrenceRuleView($rule)
    }
}
