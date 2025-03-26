//
// VerticalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Defines how content should be aligned vertically within its container
public enum VerticalAlignment: Equatable, Sendable {
    /// Align content to the top
    case top
    /// Center content vertically
    case center
    /// Align content to the bottom
    case bottom

    /// The Bootstrap class for the container with this alignment
    var containerAlignmentClass: String {
        switch self {
        case .top: "align-items-start"
        case .center: "align-items-center"
        case .bottom: "align-items-end"
        }
    }

    /// The Bootstrap class applied to items inside a container
    var itemAlignmentClass: String {
        switch self {
        case .top: "align-self-start"
        case .center: "align-self-center"
        case .bottom: "align-self-end"
        }
    }
}
