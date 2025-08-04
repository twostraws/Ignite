//
// ModifiedInlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A wrapper that applies inline element modifiers to content.
struct ModifiedInlineElement<Content: InlineElement, Modifier: InlineElementModifier>: InlineElement {
    /// The body of this HTML element, which is itself
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: Content

    /// The modifier to apply to the content.
    var modifier: Modifier

    /// Creates a modified inline element with the specified content and modifier.
    /// - Parameters:
    ///   - content: The inline element to modify.
    ///   - modifier: The modifier to apply.
    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }

    /// Renders the modified content as HTML markup.
    /// - Returns: The rendered markup with applied modifications.
    func render() -> Markup {
        let proxy = InlineModifiedContentProxy(content: content, modifier: modifier)
        var modified = modifier.body(content: proxy)
        modified.attributes.merge(attributes)
        return modified.render()
    }
}

extension ModifiedInlineElement: LinkProvider where Content: LinkProvider {
    var url: String {
        content.url
    }
}

extension ModifiedInlineElement: ImageProvider where Content: ImageProvider {}

extension ModifiedInlineElement: ColumnProvider where Content: ColumnProvider {}
