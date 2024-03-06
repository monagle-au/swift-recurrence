import Foundation

/// Allows a raw enum type to be compared by the underlying comparable RawValue
public protocol RawComparable : Comparable where Self : RawRepresentable, RawValue: Comparable {
}

extension RawComparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
