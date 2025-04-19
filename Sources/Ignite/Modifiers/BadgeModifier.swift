//
// BadgeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adds a badge to the right side of this element.
    ///
    /// Use badges to add small, supplementary information to any inline element.
    /// The badge will be automatically positioned and styled.
    ///
    /// ```swift
    /// Text("Notifications")
    ///     .badge(Badge("3"))
    /// ```
    ///
    /// - Parameter badge: The badge to display.
    /// - Returns: A list item containing the original content and badge.
    func badge(_ badge: Badge) -> some HTML {
        ListItem {
            self
            badge
        }
        .class("d-flex", "justify-content-between", "align-items-center")
    }
}

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
