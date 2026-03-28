////
////  RecurrenceAdvancedView.swift
////  SwiftUIRecurrenceRule
////
////  Created by David Monagle on 24/2/2025.
////
//
//import SwiftUI
//
//struct RecurrenceAdvancedView: View {
//    @Binding private var recurrenceRule: Calendar.RecurrenceRule
//    
//    init(binding recurrenceRule: Binding<Calendar.RecurrenceRule>) {
//        self._recurrenceRule = recurrenceRule
//    }
//    
//    var body: some View {
//        Picker("First Day of Week", selection: $recurrenceRule.calendar.firstWeekday) {
//            Text("Sunday").tag(1)
//            Text("Monday").tag(2)
//            Text("Tuesday").tag(3)
//            Text("Wednesday").tag(4)
//            Text("Thursday").tag(5)
//            Text("Friday").tag(6)
//            Text("Saturday").tag(7)
//        }
//    }
//}
//
//#Preview {
//    @Previewable @State var recurrenceRule: Calendar.RecurrenceRule = .weekly(calendar: .autoupdatingCurrent)
//    Form {
//        RecurrenceAdvancedView(binding: $recurrenceRule)
//    }
//}
