//
//  RecurrenceMonthlyOrdinalPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import Foundation
import RecurrenceRule

public struct RecurrenceMonthlyOrdinalPicker: View {
    @Binding var ordinal: RecurrenceMonthlyOrdinal
    
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

