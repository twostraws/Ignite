//
// VerticalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Defines how content should be aligned vertically within its container
public enum VerticalAlignment {
    /// Align content to the top
    case top
    /// Center content vertically
    case center
    /// Align content to the bottom
    case bottom

    /// The Bootstrap class that implements this alignment
    var bootstrapClass: String {
        switch self {
        case .top: return "align-items-start"
        case .center: return "align-items-center"
        case .bottom: return "align-items-end"
        }
    }
}
