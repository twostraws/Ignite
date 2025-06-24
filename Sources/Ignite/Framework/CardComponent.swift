//
// CardComponent.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container component that wraps HTML content with customizable attributes.
///
/// `CardComponent` provides a flexible way to apply attributes to any HTML content,
/// making it useful for creating styled containers and layout components.
struct CardComponent: HTML {
    var body: some HTML { self }
    var attributes = CoreAttributes()
    var content: any HTML

    /// Creates a card component with the specified HTML content.
    /// - Parameter content: The HTML content to be wrapped by this component.
    init(_ content: any HTML) {
        self.content = content
    }

    /// Creates a card component with inline element content.
    /// - Parameter content: The inline element to be wrapped by this component.
    init<T: InlineElement>(_ content: T) {
        self.content = InlineHTML(content)
    }

    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        return content.render()
    }
}
