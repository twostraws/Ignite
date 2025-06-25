//
// Divider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A horizontal divider for your page, that can also be used to divide elements
/// in a dropdown.
public struct Divider: HTML, DropdownElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Creates a new divider.
    public init() {}

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        Markup("<hr\(attributes) />")
    }
}
