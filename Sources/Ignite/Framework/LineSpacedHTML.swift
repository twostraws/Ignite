//
// LineSpacedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

typealias LineSpacingAmount = Amount<Double, LineSpacing>

/// A container that applies line spacing to HTML content.
///
/// For text-based content, line spacing is applied directly to the element.
/// For other content types, the content is wrapped in a `Section` with
/// inherited line height styling.
struct LineSpacedHTML<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The HTML content to apply line spacing to.
    private var content: Content

    /// The spacing configuration, either exact or semantic.
    private var spacing: Amount<Double, LineSpacing>

    /// Creates a line-spaced HTML container.
    /// - Parameters:
    ///   - content: The HTML content to apply spacing to.
    ///   - spacing: The line spacing configuration.
    init(_ content: Content, spacing: LineSpacingAmount) {
        self.content = content
        self.spacing = spacing
    }

    /// Renders the line-spaced content as HTML markup.
    /// - Returns: The rendered HTML markup with applied line spacing.
    func render() -> Markup {
        return switch spacing {
        case .exact(let spacing):
            Section(content.class("line-height-inherit"))
                .attributes(attributes)
                .style(.lineHeight, spacing.formatted(.nonLocalizedDecimal))
                .render()
        case .semantic(let spacing):
            Section(content.class("line-height-inherit"))
                .attributes(attributes)
                .class("lh-\(spacing.rawValue)")
                .render()
        default:
            content
                .attributes(attributes)
                .render()
        }
    }
}
