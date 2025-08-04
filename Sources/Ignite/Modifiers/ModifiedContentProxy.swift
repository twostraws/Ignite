//
// ModifiedContentProxy.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A proxy that applies HTML modifiers to content while optimizing the output structure.
public struct ModifiedContentProxy<Modifier: HTMLModifier>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// Core HTML attributes applied to the content.
    public var attributes = CoreAttributes()

    /// The modifier to apply to the content.
    private var modifier: Modifier

    /// The HTML content being modified.
    private var content: any HTML

    /// Creates a proxy that applies a modifier to HTML content.
    /// - Parameters:
    ///   - content: The HTML content to modify.
    ///   - modifier: The modifier to apply.
    init<T: HTML>(content: T, modifier: Modifier) {
        self.modifier = modifier
        self.content = content
    }

    /// Renders the modified content, optimizing div wrapping to avoid layout issues.
    public func render() -> Markup {
        if content.isPrimitive {
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        } else if content.body.isPrimitive, content.markupString().hasPrefix("<div") {
            // Unnecessarily adding an extra <div> can break positioning
            // contexts and advanced flex layouts.
            var content = content.body
            content.attributes.merge(attributes)
            return content.render()
        } else {
            return Markup("<div\(attributes)>\(content.markupString())</div>")
        }
    }
}
