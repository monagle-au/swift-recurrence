//
//  MonthSelectionView.swift
//  SwiftUIRecurrenceRule
//
//  Created by David Monagle on 24/2/2025.
//

import SwiftUI
import RecurrenceRule

/// A 6-column grid view for selecting one or more calendar months.
///
/// Each cell shows the month name (abbreviated on compact widths, full on regular widths).
/// Selected months are highlighted with the accent colour. Double-tapping a cell sets the
/// selection to that single month when `mandatory` is `true`, or clears the selection when
/// `mandatory` is `false`.
///
/// Used by ``RecurrenceRuleView`` when the yearly frequency is active.
public struct MonthSelectionView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @Binding var months: Set<RecurrenceMonth>

    private let formatter = DateFormatter()
    private let multiSelect: Bool
    private let mandatory: Bool

    /// Creates a `MonthSelectionView`.
    /// - Parameters:
    ///   - months: Binding to the set of selected months.
    ///   - multiSelect: Allows multiple selections when `true` (default `true`).
    ///   - mandatory: Prevents the selection from becoming empty when `true` (default `false`).
    public init(selection months: Binding<Set<RecurrenceMonth>>, multiSelect: Bool = true, mandatory: Bool = false) {
        self._months = months
        self.multiSelect = multiSelect
        self.mandatory = mandatory
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(MonthCell.all) { month in
                monthCellView(month)
            }
        }
        .background(PlatformColor.systemFill)
        .cornerRadius(3.0)
    }

    private var columns: [GridItem] {
        let item = GridItem(.flexible(minimum: 50, maximum: 200), spacing: 1)
        return .init(repeating: item, count: 6)
    }

    private func monthCellView(_ cell: MonthCell) -> some View {
        let isSelected = months.contains(cell.month)

        return Text(cell.name(for: horizontalSizeClass))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .font(.footnote)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(isSelected ? PlatformColor.systemBackground : .primary)
            .background(isSelected ? Color.accentColor : PlatformColor.secondarySystemBackground)
            .accessibility(identifier: "month\(cell.id)")
            .onTapGesture {
                self.toggle(cell.month)
            }
            .simultaneousGesture(
                TapGesture(count: 2).onEnded { _ in
                    self.months = mandatory ? [cell.month] : []
                }
            )
    }

    private func toggle(_ month: RecurrenceMonth) {
        if self.months.contains(month) {
            if mandatory, months.count <= 1 { return }
            self.months.remove(month)
        }
        else {
            if multiSelect {
                self.months.insert(month)
            }
            else {
                self.months = [month]
            }
        }
    }

    private struct MonthCell: Identifiable {
        static let formatter = DateFormatter()
        static let all = RecurrenceMonth.allCases.map { MonthCell(month: $0) }

        let month: RecurrenceMonth
        var id: Int { self.month.rawValue }

        func name(for horizontalSizeClass: UserInterfaceSizeClass?) -> String {
            let index = month.rawValue - 1
            return horizontalSizeClass == .compact ? Self.formatter.shortMonthSymbols[index] : Self.formatter.monthSymbols[index]
        }
    }
}

#Preview {
    @Previewable @State var selectedMonths: Set<RecurrenceMonth> = [.april, .august]
    MonthSelectionView(selection: $selectedMonths, mandatory: true)
}
