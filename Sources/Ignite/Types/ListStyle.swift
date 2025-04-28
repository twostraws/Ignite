//
// ListStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The visual style to apply to a list.
public enum ListStyle: Sendable, CaseIterable {
    /// A basic list style with minimal visual treatment, ideal for simple content presentation.
    case plain

    /// A list style with distinct grouping, subtle borders, and rounded corners, \
    /// perfect for related content that needs visual separation.
    case group

    /// A horizontally arranged list with grouping and borders, designed for \
    /// content that flows left to right.
    case horizontalGroup

    /// A list style that sits flush within its container with no outer borders, \
    /// ideal for integration within cards or other containers (note: does not support numbered markers).
    case flushGroup

    /// The Bootstrap CSS classes needed to implement the list's visual style.
    var classes: [String]? {
        switch self {
        case .plain: nil
        case .group: ["list-group"]
        case .horizontalGroup: ["list-group", "list-group-horizontal"]
        case .flushGroup: ["list-group", "list-group-flush"]
        }
    }
}
