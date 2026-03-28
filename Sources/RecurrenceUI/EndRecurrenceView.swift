//
//  EndRecurrenceView.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import RecurrenceRule

struct EndRecurrenceView: View {
    @Binding private var end: RecurrenceRule.End
    @State private var occurrences: Int
    @State private var date: Date
    
    init(selection: Binding<RecurrenceRule.End>) {
        self._end = selection
        switch selection.wrappedValue {
        case .date(let date):
            _date = .init(initialValue: date)
            _occurrences = .init(initialValue: 1)
        case .occurrences(let occurrences):
            _occurrences = .init(initialValue: occurrences)
            _date = .init(initialValue: Date())
        case .never:
            _date = .init(initialValue: Date())
            _occurrences = .init(initialValue: 1)
        }
    }
    
    private var optionBinding: Binding<Option> {
        .init(
            get: {
                switch self.end {
                case .date(_):
                    return .afterDate
                case .occurrences(_):
                    return .afterOccurrences
                case .never:
                    return .never
                }
            },
            set: { newValue in
                switch newValue {
                case .never:
                    end = .never
                case .afterDate:
                    end = .date(date)
                case .afterOccurrences:
                    end = .occurrences(occurrences)
                }
            }
        )
    }
    
    var body: some View {
        Group {
            Picker("End", selection: optionBinding) {
                Text(Option.never.localizedStringKey).tag(Option.never)
                Text(Option.afterDate.localizedStringKey).tag(Option.afterDate)
                Text(Option.afterOccurrences.localizedStringKey).tag(Option.afterOccurrences)
            }
            
            switch end {
            case .date(_):
                DatePicker("Date", selection: $date, displayedComponents: [.date])
            case .occurrences(let occurrences):
                HStack {
                    Stepper("Occurrences", value: $occurrences)
                    Text("\(occurrences)")
                }
            case .never:
                Text("This will continue to occur indefinitely.")
                    .font(.callout)
            }
        }
        .onChange(of: date) { _, newDate in
            self.end = .date(newDate)
        }
        .onChange(of: occurrences) { _, newOccurrences in
            self.end = .occurrences(newOccurrences)
        }
    }
}


extension EndRecurrenceView {
    private enum Option: CaseIterable {
        case never
        case afterDate
        case afterOccurrences
        
        var localizedStringKey: LocalizedStringKey {
            switch self {
            case .never: "Never"
            case .afterDate: "After Date"
            case .afterOccurrences: "After Occurrences"
            }
        }
    }
    
    // Localized helper for pluralized occurrences label
    // Add the following key to your String Catalog (Localizable.xcstrings):
    // Key: "after_occurrences"
    // Value (English example): "After %lld occurrence" (singular) and "After %lld occurrences" (plural)
    // Use a 'count' variable of type 'Int' and configure pluralization rules in the catalog.
    private func afterOccurrencesLabel(_ count: Int) -> LocalizedStringKey {
        // Using interpolation with a localization key enables pluralization via String Catalogs
        // Define a string catalog entry with a variable named 'count' for proper plural rules.
        return LocalizedStringKey("after_occurrences \n\ncount=\(count)")
    }
}

// This is requrired to prevent compilation errors as endDate wasn't available until MacOS 15.2 and iOS 18.2. These will be required versions for release
@available(macOS 15, *)
fileprivate extension Calendar.RecurrenceRule.End {
    var bcShimDate: Date? {
        if #available(macOS 15.2, iOS 18.2, *) {
            return self.date
        } else {
            return nil
        }
    }
    
    var bcShimOccurences: Int? {
        if #available(macOS 15.2, iOS 18.2, *) {
            return self.occurrences
        } else {
            return nil
        }
    }
}



#Preview {
    @Previewable @State var end: RecurrenceRule.End = .occurrences(5)
    
    NavigationStack {
        Form {
            EndRecurrenceView(selection: $end)
        }
    }
}

