//
//  IntervalStepper.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI

struct IntervalStepper: View {
    @Binding var interval: Int

    var body: some View {
        HStack {
            Stepper(value: $interval, in: 1 ... 50) {
                Text("Every")
            }
            Text("\(interval)")
        }
    }
}

#Preview {
    @Previewable @State var interval: Int = 1
    
    Form {
        IntervalStepper(interval: $interval)
    }
}
