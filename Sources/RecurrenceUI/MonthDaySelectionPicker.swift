//
//  MonthDaySelectionPicker.swift
//  swift-recurrence
//
//  Created by David Monagle on 20/10/2025.
//

import SwiftUI

struct MonthDaySelectionPicker: View {
    @Binding var option: Option
    
    var body: some View {
        Picker("Days", selection: $option) {
            ForEach(Option.allCases, id: \.self) { day in
                Text(day.localizedStringKey)
                    .tag(day)
                    .accessibility(identifier:  "\(day.rawValue)MonthDaySelection")
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

extension MonthDaySelectionPicker {
    enum Option: String, CaseIterable {
        case every
        case onThe

        var localizedStringKey: LocalizedStringKey {
            switch self {
            case .every:
                return "Every"
            case .onThe:
                return "On the"
            }
        }
    }

}

#Preview {
    @Previewable @State var option: MonthDaySelectionPicker.Option = .onThe
    MonthDaySelectionPicker(option: $option)
}
