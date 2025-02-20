//
// GroupBox.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container element that groups its children together.
///
/// When initialized with just content, the section wraps its children in a `<div>`.
/// When initialized with a header and content, the section wraps its children in a `<section>`.
///
/// - Note: Unlike ``Group``, modifiers applied to a `Section` affect the
///         containing element rather than being propagated to child elements.
public struct Section: HTML, HorizontalAligning {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The heading text of the section.
    var header: String?

    /// The heading's semantic font size.
    var headerStyle: Font.Style = .title2

    var items: [any HTML] = []

    // Temporarily public
    public init(_ items: any HTML) {
        self.items = flatUnwrap(items)
        self.tag("div")
    }

    /// Creates a section that renders as a `div` element.
    /// - Parameter content: The content to display within this section.
    public init(@HTMLBuilder content: () -> some HTML) {
        self.items = flatUnwrap(content())
        self.tag("div")
    }

    /// Creates a section that renders as a `section` element with a heading.
    /// - Parameters:
    ///   - header: The text to display as the section's heading
    ///   - content: The content to display within this section
    public init(_ header: String, @HTMLBuilder content: () -> some HTML) {
        self.items = flatUnwrap(content())
        self.header = header
        self.tag("section")
    }

    /// Adjusts the semantic importance of the section's header by changing its font style.
    /// - Parameter fontStyle: The font style to apply to the header
    /// - Returns: A section with the modified header style
    public func headerProminence(_ fontStyle: Font.Style) -> Self {
        var copy = self
        copy.headerStyle = fontStyle
        return copy
    }

    public func render() -> String {
        var items = items
        if let header = header {
            items.insert(Text(header).fontStyle(headerStyle), at: 0)
        }
        let content = items.map { $0.render() }.joined()
        return descriptor.description(wrapping: content)
    }
}
