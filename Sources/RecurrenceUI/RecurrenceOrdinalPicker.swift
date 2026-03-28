//
//  RecurrenceOrdinalPicker.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import Foundation
import RecurrenceCore

public struct RecurrenceOrdinalPicker: View {
    @Binding var ordinal: RecurrenceOrdinal
    
    public init(_ ordinal: Binding<RecurrenceOrdinal>) {
        self._ordinal = ordinal
    }
    
    public var body: some View {
        Picker("On the", selection: $ordinal) {
            ForEach(RecurrenceOrdinal.allCases, id: \.self) { ordinal in
                Text(ordinal.localizedStringKey)
                    .accessibility(identifier: "monthlyOrdinal\(ordinal.rawValue)")
                    .tag(ordinal)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

extension RecurrenceOrdinal {
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
        case .last:
            "Last"
        }
    }
}

#Preview {
    @Previewable @State var ordinal: RecurrenceOrdinal = .third
    
    Form {
        RecurrenceOrdinalPicker($ordinal)
    }
}

