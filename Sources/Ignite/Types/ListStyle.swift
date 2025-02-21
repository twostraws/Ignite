//
// ListStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The visual style to apply to a list.
///
/// Use list styles to control the appearance and layout of lists in your interface.
/// Each style provides a distinct visual treatment that helps communicate the list's
/// purpose and hierarchy.
///
/// - Note: The `groupFlush` style does not support numbered markers.
public enum ListStyle: Sendable {
    /// A simple list with minimal styling.
    ///
    /// Use this style when you want a basic list without additional visual treatments.
    case plain

    /// A list with distinct grouping and subtle borders.
    ///
    /// This style adds visual separation between list items and a border around the
    /// entire list, making it ideal for related content that benefits from clear grouping.
    case group

    /// A list with edge-to-edge items and no outer borders.
    ///
    /// Similar to `group` but removes outer borders and rounded corners, making it
    /// ideal for lists that need to sit flush within a parent container like a card.
    ///
    /// - Important: This style does not support numbered markers.
    case flushGroup
}
