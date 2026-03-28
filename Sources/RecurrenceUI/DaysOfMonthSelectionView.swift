//
//  DaysOfMonthSelectionView.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import RecurrenceRule

/// A 7-column grid view for selecting specific days of the month (1–31).
///
/// Cells are rendered in a grid that mirrors a calendar layout. Selected days are highlighted
/// with the accent colour. Double-tapping a cell sets the selection to that single day when
/// `minSelections > 0`, or clears the selection otherwise.
///
/// Used by ``RecurrenceRuleView`` when the monthly or annual frequency is active with an
/// `.every` day selection strategy.
///
/// ## Parameters
/// - `daysOfMonth`: Binding to the selected days (integers 1–31).
/// - `maxSize`: Maximum cell size in points (default `64`).
/// - `multiSelect`: Allows multiple days when `true` (default `true`).
/// - `minSelections`: Minimum number of days that must remain selected, or `nil` for no minimum.
/// - `maxSelections`: Maximum number of days that can be selected, or `nil` for no maximum.
public struct DaysOfMonthSelectionView: View {
    @Binding var daysOfMonth: Set<Int>

    private var multiSelect: Bool
    private var maxSize: CGFloat?
    private var maxSelections: Int?
    private var minSelections: Int?
    @State private var rowHeight: CGFloat = .zero

    /// Creates a `DaysOfMonthSelectionView`.
    /// - Parameters:
    ///   - daysOfMonth: Binding to the selected days (1–31).
    ///   - maxSize: Maximum cell size in points (default `64`).
    ///   - multiSelect: Allows multiple selections when `true` (default `true`).
    ///   - minSelections: Minimum number of days that must remain selected (default `nil`).
    ///   - maxSelections: Maximum number of days that can be selected (default `nil`).
    public init(selection daysOfMonth: Binding<Set<Int>>, maxSize: CGFloat? = 64, multiSelect: Bool = true, minSelections: Int? = nil, maxSelections: Int? = nil) {
        self._daysOfMonth = daysOfMonth
        self.maxSize = maxSize
        self.multiSelect = multiSelect
        self.minSelections = minSelections
        self.maxSelections = maxSelections
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(1..<32) { day in
                cell(day)
                    .cornerRadius(3.0, for: day)
            }
        }
    }

    private var columns: [GridItem] {
        let item = GridItem(.flexible(minimum: 30, maximum: 60), spacing: 1)
        return .init(repeating: item, count: 7)
    }

    private func cell(_ day: Int) -> some View {
        let isSelected = self.daysOfMonth.contains(day)

        return Text("\(day)")
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(isSelected ? PlatformColor.systemBackground : .primary)
            .accessibility(identifier: "day\(day)")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .aspectRatio(1.0, contentMode: .fit)
        .background(isSelected ? Color.accentColor : PlatformColor.secondarySystemBackground)
        .onTapGesture {
            self.toggle(day)
        }
        .simultaneousGesture(
            TapGesture(count: 2).onEnded { _ in
                self.daysOfMonth = (minSelections ?? 0) > 0 ? [day] : []
            }
        )

    }

    private func toggle(_ day: Int) {
        if self.daysOfMonth.contains(day) {
            if let min = minSelections, daysOfMonth.count <= min { return }
            self.daysOfMonth.remove(day)
        }
        else {
            if multiSelect {
                if let max = maxSelections, daysOfMonth.count >= max { return }
                self.daysOfMonth.insert(day)
            }
            else {
                self.daysOfMonth = [day]
            }
        }
    }
}

fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, for day: Int) -> some View {
        #if os(iOS)
        let corners: UIRectCorner

        switch day {
        case 1:
            corners = [.topLeft]
        case 7:
            corners = [.topRight]
        case 28:
            corners = [.bottomRight]
        case 29:
            corners = [.bottomLeft]
        case 31:
            corners = [.bottomRight]
        default:
            corners = []
        }

        return self.cornerRadius(radius, corners: corners)
        #else
        return self
        #endif
    }
}

#if canImport(UIKit)

struct ExCornerRadius: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}

public extension View {
    /// Rounds the given corners by clipping the shape
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(ExCornerRadius(radius: radius, corners: corners))
    }
}

#endif


#Preview {
    @Previewable @State var selectedDays: Set<Int> = [1, 3, 5, 7, 9]
    Form {
        DaysOfMonthSelectionView(selection: $selectedDays)
    }
}
