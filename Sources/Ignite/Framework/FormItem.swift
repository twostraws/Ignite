//
// FormItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A wrapper that applies form-specific configuration to HTML content.
struct FormItem: HTML {
    var body: some HTML { self }

    var attributes = CoreAttributes()

    private var configuration = FormConfiguration()

    /// The HTML content to be wrapped with form configuration.
    private var content: any HTML

    /// Creates a form item with the specified HTML content.
    /// - Parameter content: The HTML content to wrap.
    init(_ content: any HTML) {
        self.content = content
    }

    /// Applies form configuration to this item.
    /// - Parameter configuration: The form configuration to apply.
    /// - Returns: A new form item with the specified configuration.
    func formConfiguration(_ configuration: FormConfiguration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    /// Renders the form item as markup.
    /// - Returns: The rendered markup with form configuration applied.
    func render() -> Markup {
        var content = content
        content.attributes.merge(attributes)
        if let content = content as? any FormElementRenderable {
            return content.renderAsFormElement(configuration)
        }
        return content.render()
    }
}
