//
//  RecurrenceMonthlyOrdinalPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import Foundation
import RecurrenceRule

/// A segmented picker for selecting the ordinal position of a weekday within a month.
///
/// Presents segments for First, Second, Third, Fourth, Fifth, 2nd Last, and Last. Used in
/// conjunction with ``WeekdayPicker`` to compose patterns such as "the last Friday of each month".
///
/// Corresponds to the ``RecurrenceMonthlyOrdinal`` model type.
public struct RecurrenceMonthlyOrdinalPicker: View {
    @Binding var ordinal: RecurrenceMonthlyOrdinal

    /// Creates a `RecurrenceMonthlyOrdinalPicker` bound to the given ordinal.
    /// - Parameter ordinal: A binding to the selected ``RecurrenceMonthlyOrdinal``.
    public init(_ ordinal: Binding<RecurrenceMonthlyOrdinal>) {
        self._ordinal = ordinal
    }

    public var body: some View {
        Picker("On the", selection: $ordinal) {
            ForEach(RecurrenceMonthlyOrdinal.allCases, id: \.self) { ordinal in
                Text(ordinal.localizedStringKey)
                    .accessibility(identifier: "monthlyOrdinal\(ordinal.rawValue)")
                    .tag(ordinal)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

extension RecurrenceMonthlyOrdinal {
    var localizedStringKey: String {
        switch self {
        case .first:
            "First"
        case .second:
            "Second"
        case .third:
            "Third"
        case .fourth:
            "Fourth"
        case .fifth:
            "Fifth"
        case .secondLast:
            "2nd Last"
        case .last:
            "Last"
        }
    }
}

#Preview {
    @Previewable @State var ordinal: RecurrenceMonthlyOrdinal = .third

    Form {
        RecurrenceMonthlyOrdinalPicker($ordinal)
    }
}
