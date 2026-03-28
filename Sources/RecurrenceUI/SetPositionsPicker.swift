////
////  SwiftUIView.swift
////  SwiftUIRecurrenceRule
////
////  Created by David Monagle on 24/2/2025.
////
//
//import SwiftUI
//
//struct SetPositionsPicker: View {
//    @Binding private var setPositions: [Int]
//    
//    init(selection setPositions: Binding<[Int]>) {
//        self._setPositions = setPositions
//    }
//    
//    private var selectionBinding: Binding<Option> {
//        .init(
//            get: {
//                guard let firstValue = self.setPositions.first else {
//                    return .all
//                }
//                return .init(rawValue: firstValue) ?? .all
//            },
//            set: { newValue in
//                switch newValue {
//                case .all:
//                    self.setPositions = []
//                default:
//                    self.setPositions = [newValue.rawValue]
//                }
//                
//            }
//        )
//    }
//    
//    var body: some View {
//        Picker("Set Position", selection: selectionBinding) {
//            Text("All").tag(Option.all)
//            Text("First").tag(Option.first)
//            Text("Last").tag(Option.last)
//        }
//    }
//    
//    enum Option: Int, CaseIterable {
//        case all = 0
//        case first = 1
//        case last = -1
//    }
//}
//
//#Preview {
//    @Previewable @State var setPositions: [Int] = []
//    Form {
//        SetPositionsPicker(selection: $setPositions)
//    }
//}
