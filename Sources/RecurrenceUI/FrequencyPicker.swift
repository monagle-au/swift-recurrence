//
//  FrequencyPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import Foundation
import RecurrenceRule

public struct FrequencyPicker: View {
    @Binding var option: Option
    
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
    public enum Option: Sendable, Codable, CaseIterable {
        case daily
        case weekly
        case monthly
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

