//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
    private var items: [any FormItem]

    /// The style of labels in the form
    private var labelStyle: ControlLabelStyle = .floating

    /// The size of form controls and labels
    private var controlSize: ControlSize = .medium

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    var isNavigationItem = false

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

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    public init(
        spacing: SpacingAmount = .medium,
        @ElementBuilder<FormItem> content: () -> [any FormItem]
    ) {
        self.items = content()
        self.spacing = spacing
        attributes.id = UUID().uuidString.truncatedHash
    }

    public func markup() -> Markup {
        if isNavigationItem {
            renderInNavigationBar()
        } else {
            renderNormally()
        }
    }

    /// Renders the form in a compact format suitable for navigation bars.
    /// - Returns: A string containing the rendered HTML optimized for navigation contexts.
    private func renderInNavigationBar() -> Markup {
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

        let contentHTML = items.map { $0.markupString() }.joined()
        return Markup("<form\(attributes)>\(contentHTML)</form>")
    }

    private func renderNormally() -> Markup {
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
                if let textField = item.as(TextField.self) {
                    renderTextField(textField)
                } else if let button = item.as(Button.self) {
                    renderButton(button)
                } else if let group = item.as(ControlGroup.self) {
                    renderControlGroup(group)
                } else if let span = item.as(Span.self) {
                    renderText(span)
                } else if let section = item.as(Section.self) {
                    renderSection(section)
                } else {
                    renderItem(item)
                }
            }
        }
        .attributes(attributes)
        .class(labelStyle == .leading ? nil : "row g-\(spacing.rawValue)")
        .markup()
    }

    @HTMLBuilder
    private func renderTextField(_ textField: TextField) -> some HTML {
        let styledTextField = textField.size(controlSize).labelStyle(labelStyle)
        switch labelStyle {
        case .leading: styledTextField
        default: Section(styledTextField).class(getColumnClass(for: textField, totalColumns: columnCount))
        }
    }

    private func renderControlGroup(_ group: ControlGroup) -> some HTML {
        group.labelStyle(labelStyle)
    }

    private func renderSection(_ section: Section) -> some HTML {
        var items = HTMLCollection([section.content]).elements

        let last = items.last

        items = items.dropLast().map {
            $0.class("mb-\(spacing.rawValue)")
        }

        if let last {
            items.append(last)
        }

        return Tag("fieldset") {
            if let header = section.header {
                Tag("legend") {
                    header
                }
                .class(labelStyle == .leading ? "col-form-label col-sm-2" : nil)
            }

            ForEach(items) { item in
                if let controlGroup = item.as(ControlGroup.self) {
                    controlGroup
                        .labelStyle(labelStyle)
                } else if let textField = item.as(TextField.self) {
                    textField
                        .labelStyle(labelStyle)
                } else {
                    AnyHTML(item)
                }
            }
        }
        .attributes(section.attributes)
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

    private func renderItem(_ item: any BodyElement) -> some HTML {
        Section(item)
            .class("d-flex", "align-items-center")
            .class(getColumnClass(for: item, totalColumns: columnCount))
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(
        for item: any BodyElement,
        totalColumns: Int
    ) -> String {
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }),
           let width = Int(widthClass.dropFirst("col-md-".count)) {
            let bootstrapColumns = 12 * width / totalColumns
            return "col-md-\(bootstrapColumns)"
        } else if item.attributes.classes.contains("col") {
            return "col"
        } else {
            return "col-auto"
        }
    }
}

extension Form: NavigationItemConfigurable {}
