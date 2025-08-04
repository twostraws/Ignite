//
// ListStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The visual style to apply to a list.
public enum ListStyle: Sendable, CaseIterable {
    /// A basic list appearance with no styling.
    case automatic

    /// A list style with subtle borders and rounded corners.
    case group

    /// A list style with subtle borders and rounded corners, arranged horizontally.
    case horizontalGroup

    /// A list style with separators between items.
    case plain

    /// The Bootstrap CSS classes needed to implement the list's visual style.
    var classes: [String]? {
        switch self {
        case .automatic: nil
        case .group: ["list-group"]
        case .horizontalGroup: ["list-group", "list-group-horizontal"]
        case .plain: ["list-group", "list-group-flush"]
        }
    }
}
