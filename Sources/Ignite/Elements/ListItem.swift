//
// ListItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates one item in a list. This isn't always needed, because you can place other
/// elements directly into lists if you wish. Use `ListItem` when you specifically
/// need a styled HTML <li> element.
public struct ListItem<Content: HTML, BadgeContent: InlineElement>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content of this list item.
    private var content: Content

    /// The badge for this list item.
    private var badge: Badge<BadgeContent>?

    /// Configures this list item to properly display a badge.
    /// - Parameter badge: The badge to display.
    /// - Returns: A modified list item with proper badge styling.
    public func badge<T: InlineElement>(_ badge: Badge<T>) -> some HTML {
        var item = ListItem<Content, T>(self.content, badge: badge)
        item.attributes.append(classes: "d-flex", "justify-content-between", "align-items-center")
        return item
    }

    /// Sets the role for this list item, which controls its appearance.
    /// - Parameter role: The new role to apply.
    /// - Returns: A new `ListItem` instance with the updated role.
    /// - Note: The role modifier only has an effect when the parent list's style is `.group`.
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.attributes.append(classes: "list-group-item-\(role.rawValue)")
        return copy
    }

    /// Creates a new `ListItem` object using an inline element builder that
    /// returns an array of `HTML` objects to display in the list.
    /// - Parameter content: The content you want to display in your list.
    public init(@HTMLBuilder content: () -> Content) where BadgeContent == EmptyInlineElement {
        self.content = content()
    }

    /// Creates a new `ListItem` object from a peice of HTML content.
    /// - Parameter content: The content you want to display in your list.
    init(_ content: Content) where BadgeContent == EmptyInlineElement {
        self.content = content
    }

    /// Creates a new `ListItem` object from a peice of HTML content.
    /// - Parameters:
    ///    - content: The content you want to display in your list.
    ///    - badge: The badge to display at the end of the item.
    init(_ content: Content, badge: Badge<BadgeContent>) {
        self.content = content
        self.badge = badge
    }

    /// Creates a new `ListItem` object from a peice of HTML content.
    /// - Parameter content: The content you want to display in your list.
    init<T: InlineElement>(_ content: T) where Content == InlineHTML<T>, BadgeContent == EmptyInlineElement {
        self.content = InlineHTML(content)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        let badgeHTML = badge?.markupString() ?? ""
        return Markup("<li\(attributes)>\(contentHTML)\(badgeHTML)</li>")
    }
}

extension ListItem: ListItemProvider {}

extension ListItem: NavigationElement where Content: NavigationElement {}
