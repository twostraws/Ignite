//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that is rendered differently when placed in a `Form`.
@MainActor
protocol FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup
}

/// A form container for collecting user input
public struct Form<Content: HTML>: HTML, NavigationElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How a `NavigationBar` displays this item at different breakpoints.
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// The form elements to be rendered.
    private var content: Content

    /// The configuration of the form.
    private var configuration = FormConfiguration()

    /// Sets the style for form labels
    /// - Parameter style: How labels should be displayed
    /// - Returns: A modified form with the specified label style
    public func labelStyle(_ style: ControlLabelStyle) -> Self {
        var copy = self
        copy.configuration.labelStyle = style
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.configuration.controlSize = size
        return copy
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    @available(*, deprecated, message: "All forms now have a fixed width of 12 columns.")
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.configuration.columnCount = columns
        return copy
    }

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    public init(
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration.spacing = spacing
        attributes.id = UUID().uuidString.truncatedHash
    }

    public func render() -> Markup {
        return Tag("form") {
            ForEach(content.subviews()) { item in
                FormItem(item.wrapped)
                    .formConfiguration(configuration)
                    .class(configuration.labelStyle == .leading ? "mb-\(configuration.spacing.rawValue)" : nil)
            }
        }
        .attributes(attributes)
        .class(configuration.labelStyle == .leading ? nil : "row g-\(configuration.spacing.rawValue)")
        .render()
    }
}
