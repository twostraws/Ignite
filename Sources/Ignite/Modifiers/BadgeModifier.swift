//
// BadgeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension ListItem {
    /// Configures this list item to properly display a badge.
    ///
    /// Call this method when you've manually added a badge to a list item's content
    /// to ensure correct layout and spacing.
    ///
    /// ```swift
    /// ListItem {
    ///     Text("Messages")
    /// }
    /// .badge(Badge("3"))
    /// ```
    ///
    /// - Parameter badge: The badge to display.
    /// - Returns: A modified list item with proper badge styling.
    func badge(_ badge: Badge) -> some HTML {
        self.class("d-flex", "justify-content-between", "align-items-center")
    }
}
