import SwiftUI

#if canImport(UIKit)
import UIKit
enum PlatformColor {
    static var systemBackground: Color { Color(UIColor.systemBackground) }
    static var secondarySystemBackground: Color { Color(UIColor.secondarySystemBackground) }
    static var systemFill: Color { Color(UIColor.systemFill) }
}
#elseif canImport(AppKit)
import AppKit
enum PlatformColor {
    static var systemBackground: Color { Color(NSColor.windowBackgroundColor) }
    static var secondarySystemBackground: Color { Color(NSColor.controlBackgroundColor) }
    static var systemFill: Color { Color(NSColor.controlColor) }
}
#endif
