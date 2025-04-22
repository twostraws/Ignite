//
// DocumentStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type for adding internal CSS styles to an HTML document.
public struct DocumentStyle: HeadElement {
    /// The importance of the internal styles.
    public enum Priority: Sendable {
        /// The default priority.
        case normal
        /// A higher priority denoted by `!important`.
        case important
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The selector to use in the style's declaration block.
    private let selector: String

    /// The CSS declarations to apply.
    private let style: any Style

    /// The importance of the style declarations.
    private let priority: Priority

    /// Creates a new `DocumentStyle` object using the styles and selector provided.
    /// - Parameters:
    ///   - selector: The selector of the style's declaration block.
    ///   - priority: The level of importance of the styles.
    ///   - style: The `Style` that holds the appropriate CSS.
    public init(_ selector: String, priority: Priority = .normal, style: any Style) {
        self.selector = selector
        self.style = style
        self.priority = priority
    }

    public func markup() -> Markup {
        let allThemes = publishingContext.site.allThemes
        let css = StyleManager.shared.generateCSS(
            style: style,
            selector: .type(selector),
            isImportant: priority == .important,
            themes: allThemes)
        return Markup("<style>\(css)</style>")
    }
}
