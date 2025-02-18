//
// Divider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A horizontal divider for your page, that can also be used to divide elements
/// in a dropdown.
public struct Divider: HTML, DropdownItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Creates a new divider.
    public init() {}

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.selfClosingTag = "hr"
        return attributes.description()
    }
}
