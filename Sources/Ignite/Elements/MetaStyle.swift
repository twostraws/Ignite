//
// MetaStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type for adding internal CSS styles to an HTML document.
public struct MetaStyle: HeadElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The selector to use in the style's declaration block.
    private let selector: String

    /// The CSS declarations to apply.
    private let style: any Style

    /// Whether the properties of this block should be marked `!important`.
    private var isImportant: Bool = false

    /// Marks the style declarations as important, which gives them higher priority in CSS.
    /// This is equivalent to adding `!important` to each CSS property.
    /// - Returns: A new `DocumentStyle` instance with the important flag set to true.
    public func important() -> Self {
        var copy = self
        copy.isImportant = true
        return copy
    }

    /// Creates a new `MetaStyle` object using the styles and selector provided.
    /// - Parameters:
    ///   - selector: The selector of the style's declaration block.
    ///   - style: The `Style` that holds the appropriate CSS.
    public init(_ selector: String, style: any Style) {
        self.selector = selector
        self.style = style
    }

    public func render() -> Markup {
        let allThemes = publishingContext.site.allThemes
        let css = StyleManager.shared.generateCSS(
            style: style,
            selector: .type(selector),
            isImportant: isImportant,
            themes: allThemes)
        return Markup("<style>\(css)</style>")
    }
}
