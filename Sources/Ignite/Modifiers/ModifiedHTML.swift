//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ModifiedHTML: HTML, InlineHTML, BlockHTML, RootHTML, NavigationItem {
    var columnWidth: ColumnWidth = .automatic
    var id = UUID().uuidString.truncatedHash
    var body: some HTML { self }
    var isPrimitive: Bool = true
    private(set) var content: any HTML

    init(_ content: any HTML, modifier: any HTMLModifier) {
        // First handle the content assignment and unwrapping
        if let modified = content as? ModifiedHTML {
            self.content = modified.content
        } else {
            self.content = content
        }

        // Apply the modifier to get the modified version
        let modifiedContent: any HTML = modifier.body(content: self.content)

        // Merge attributes in the correct order:
        // 1. Original content attributes
        AttributeStore.default.merge(self.content.attributes, intoHTML: id)

        // 2. If the content was a ModifiedHTML, get its attributes too
        if let modified = content as? ModifiedHTML {
            AttributeStore.default.merge(modified.attributes, intoHTML: id)
        }

        // 3. Finally merge the modifier's new attributes
        AttributeStore.default.merge(modifiedContent.attributes, intoHTML: id)

        // Handle column width for block elements
        if let block = self.content as? (any BlockHTML) {
            self.columnWidth = block.columnWidth
        }
    }

    func render(context: PublishingContext) -> String {
        if content.isPrimitive {
            // For primitive content, let it handle its own rendering
            return content.render(context: context)
        } else {
            // For non-primitive content:
            // 1. Get the rendered content
            let rawContent = content.render(context: context)

            // 2. Get our attributes and merge with content's attributes
            var attrs = attributes
            if attrs.tag == nil { attrs.tag = "div" }

            // 3. Return the wrapped content with all attributes
            return attrs.description(wrapping: rawContent)
        }
    }
}
