//
// ControlGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that groups related form controls into a unified visual component.
public struct ControlGroup: Element, FormItem {
    /// Defines the size variants available for control groups.
    public enum ControlSize: String, Sendable, CaseIterable {
        /// Creates a smaller, more compact control group.
        case small = "input-group-sm"
        /// Creates a standard-sized control group.
        case medium = ""
        /// Creates a larger, more expanded control group.
        case large = "input-group-lg"
    }

    /// The content and behavior of this HTML.
    public var body: some Element { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The label text for the control group.
    private let label: String?

    /// The help text displayed below the control group.
    private var helpText: (any InlineElement)?

    /// The collection of form items contained within this control group.
    private let items: [any FormItem]

    /// The size configuration for the control group.
    private var size: ControlSize?

    /// The style used for displaying labels.
    private var labelStyle: ControlLabelStyle = .floating

    /// Creates a control group with an optional label and the specified form items.
    /// - Parameters:
    ///   - label: An optional label describing the purpose of the control group.
    ///   - items: A closure returning an array of form items to include in the group.
    public init(
        _ label: String? = nil,
        @ContentBuilder<FormItem> items: () -> [any FormItem]
    ) {
        self.label = label
        self.items = items()
        self.helpText = nil
    }

    /// Sets the size of the control group.
    /// - Parameter size: The desired size for the control group.
    /// - Returns: A modified control group with the specified size.
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adds descriptive help text below the control group.
    /// - Parameter text: The help text to display, or nil to remove existing help text.
    /// - Returns: A modified control group with the specified help text.
    public func helpText(_ text: String?) -> Self {
        var copy = self
        copy.helpText = text
        return copy
    }

    /// Sets the style for displaying labels within the control group.
    /// - Parameter style: The label style to apply to the control group.
    /// - Returns: A modified control group with the specified label style.
    func labelStyle(_ style: ControlLabelStyle) -> Self {
        var copy = self
        copy.labelStyle = style
        return copy
    }

    public func render() -> String {
        var items = items
        let lastItem = items.last
        if var lastItem = lastItem as? Dropdown {
            lastItem = lastItem.configuration(.lastControlGroupItem)
            items = items.dropLast()
            items.append(lastItem)
        }

        let content = Section {
            ForEach(items) { item in
                switch item {
                case let item as TextField:
                    renderTextField(item)
                case let button as Button:
                    renderButton(button)
                case let item as Span:
                    renderText(item)
                case let dropdown as Dropdown:
                    renderDropdown(dropdown)
                default:
                    AnyHTML(item)
                }
            }
        }
        .attributes(attributes)
        .class("input-group")
        .class(size?.rawValue)

        guard label != nil || helpText != nil else {
            return content.render()
        }

        return Section {
            if let label {
                ControlLabel(label)
                    .class("form-label")
            }

            content

            if let helpText {
                Section(helpText)
                    .class("form-text")
            }
        }
        .render()
    }

    private func renderText(_ text: Span) -> any InlineElement {
        text.class("input-group-text")
    }

    private func renderTextField(_ textField: TextField) -> some InlineElement {
        var textField = textField.labelStyle(labelStyle)
        if labelStyle != .floating {
            textField.label = nil
        }
        return textField
    }

    private func renderButton(_ button: Button) -> any InlineElement {
        var button = button
        button.type = .plain
        return button
    }

    private func renderDropdown(_ dropdown: Dropdown) -> any Element {
        dropdown.configuration(.controlGroupItem)
    }
}
