//
//  FrequencyPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import Foundation
import RecurrenceRule

/// A segmented picker for choosing a recurrence frequency.
///
/// Presents four segments: Daily, Weekly, Monthly, and Yearly. Bind the selected ``Option``
/// to a state variable and react to changes to update the rest of the recurrence UI.
///
/// ## Example
/// ```swift
/// @State var frequency: FrequencyPicker.Option = .weekly
/// FrequencyPicker($frequency)
/// ```
public struct FrequencyPicker: View {
    @Binding var option: Option

    /// Creates a `FrequencyPicker` bound to the given option.
    /// - Parameter option: A binding to the currently selected ``Option``.
    public init(_ option: Binding<Option>) {
        self._option = option
    }

    public var body: some View {
        Picker(selection: $option) {
            ForEach(Option.allCases, id: \.self) { option in
                Text(option.localizedStringKey).tag(option)
            }
        } label: {
            Text("Frequency")
            Text("Select the frequency for the recurrence")
        }
        .pickerStyle(.segmented)
    }
}

extension FrequencyPicker {
    /// The four frequency options presented by ``FrequencyPicker``.
    public enum Option: Sendable, Codable, CaseIterable {
        /// Repeat every day (or every N days).
        case daily
        /// Repeat on specific days of the week.
        case weekly
        /// Repeat on specific days of the month.
        case monthly
        /// Repeat on specific months and days each year.
        case yearly
    }
}

extension FrequencyPicker.Option {
    public var localizedStringKey: LocalizedStringKey {
        switch self {
        case .daily:
            "Daily"
        case .weekly:
            "Weekly"
        case .monthly:
            "Monthly"
        case .yearly:
            "Yearly"
        @unknown default:
            "Unknown"
        }
    }
}

#Preview {
    @Previewable @State var frequencyOption: FrequencyPicker.Option = .monthly

    Form {
        FrequencyPicker($frequencyOption)
    }
}
