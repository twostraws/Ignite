//
// ControlGroupItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque wrapper for an element of a `ControlGroup.`
struct ControlGroupItem: HTML {
    var body: Never { fatalError() }

    /// Core HTML attributes applied to the item.
    var attributes = CoreAttributes()

    /// The HTML content to be rendered.
    var content: any HTML

    /// Creates a control group item with HTML content.
    /// - Parameter content: The HTML content to wrap.
    init(_ content: any HTML) {
        self.content = content
    }

    /// Creates a control group item with inline element content.
    /// - Parameter content: The inline element to wrap.
    init<T: InlineElement>(_ content: T) {
        self.content = InlineHTML(content)
    }

    /// Renders the item's content with merged attributes.
    /// - Returns: The rendered markup.
    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        return content.render()
    }
}
