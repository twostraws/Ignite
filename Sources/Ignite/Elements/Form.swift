//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into forms.
public protocol FormItem: HTML {}

/// A form container for collecting user input
public struct Form: HTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var spacing: SpacingAmount

    /// The form elements to be rendered.
    private var items: HTMLCollection

    /// The style of labels in the form
    private var labelStyle: ControlLabelStyle = .floating

    /// The size of form controls and labels
    private var controlSize: ControlSize = .medium

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    private var isNavigationItem = false

    /// Sets the style for form labels
    /// - Parameter style: How labels should be displayed
    /// - Returns: A modified form with the specified label style
    public func labelStyle(_ style: ControlLabelStyle) -> some HTML {
        var copy = self
        copy.labelStyle = style
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.controlSize = size
        return copy
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> some HTML {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Configures this dropdown to be placed inside a `NavigationBar`.
    /// - Returns: A new `Form` instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem() -> Self {
        var copy = self
        copy.isNavigationItem = true
        return copy
    }

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    public init(
        spacing: SpacingAmount = .medium,
        @ElementBuilder<FormItem> content: () -> [any FormItem]
    ) {
        self.items = HTMLCollection(content())
        self.spacing = spacing
        attributes.id = UUID().uuidString.truncatedHash
    }

    public func render() -> String {
        if isNavigationItem {
            renderInNavigationBar()
        } else {
            renderStandalone()
        }
    }

    /// Renders the form in a compact format suitable for navigation bars.
    /// - Returns: A string containing the rendered HTML optimized for navigation contexts.
    private func renderInNavigationBar() -> String {
        var items = items.map {
            if let textField = $0.as(TextField.self) {
                textField
                    .labelStyle(.hidden)
                    .size(controlSize)
            } else if $0.is(Button.self) {
                $0.class(controlSize.buttonClass)
            } else {
                $0
            }
        }

        let last = items.last

        items = items.dropLast().map {
            $0.class("me-2")
        }

        if let last {
            items.append(last)
        }

        var attributes = attributes
        attributes.append(classes: "d-flex")
        let content = items.map { $0.render() }.joined()
        return "<form\(attributes)>\(content)</form>"
    }

    private func renderStandalone() -> String {
        let items = items.map { item in
            if labelStyle == .leading {
                var item = item
                item.attributes.append(classes: "mb-\(spacing.rawValue)")
                return item
            } else {
                return item
            }
        }

        return Tag("form") {
            ForEach(items) { item in
                switch item {
                case let textField as TextField:
                    renderTextField(textField)
                case let button as Button:
                    renderButton(button)
                case let group as ControlGroup:
                    renderControlGroup(group)
                case let span as Span:
                    renderText(span)
                default:
                    renderItem(item)
                }
            }
        }
        .attributes(attributes)
        .class(labelStyle == .leading ? nil : "row g-\(spacing.rawValue)")
        .render()
    }

    @HTMLBuilder private func renderTextField(_ textField: TextField) -> some HTML {
        let styledTextField = textField.size(controlSize).labelStyle(labelStyle)
        switch labelStyle {
        case .leading: styledTextField
        default: Section(styledTextField).class(getColumnClass(for: textField, totalColumns: columnCount))
        }
    }

    private func renderControlGroup(_ group: ControlGroup) -> some HTML {
        group.labelStyle(labelStyle)
    }

    private func renderButton(_ button: Button) -> some HTML {
        Section(button.class(controlSize.buttonClass))
            .class(getColumnClass(for: button, totalColumns: columnCount))
            .class("d-flex")
            .class(labelStyle == .floating ? "align-items-stretch" : "align-items-end")
    }

    private func renderText(_ text: Span) -> some HTML {
        print("""
        For proper alignment within Form, prefer a read-only, \
        plain-text TextField over a Span.
        """)
        return renderItem(text)
    }

    private func renderItem(_ item: any HTML) -> some HTML {
        Section(item)
            .class("d-flex", "align-items-center")
            .class(getColumnClass(for: item, totalColumns: columnCount))
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(for item: any HTML, totalColumns: Int) -> String {
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }),
           let width = Int(widthClass.dropFirst("col-md-".count)) {
            let bootstrapColumns = 12 * width / totalColumns
            return "col-md-\(bootstrapColumns)"
        } else {
            return "col-auto"
        }
    }
}
