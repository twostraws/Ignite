//
// TextField.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A text input field for collecting user information in forms.
public struct TextField<Label: InlineElement>: InlineElement, ControlGroupElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The label text for the field
    var label: ControlLabel<Label>?

    /// The underlying HTML input element.
    private var input = Input()

    /// The size configuration for the text field and its label.
    private var size: ControlSize = .medium

    /// The positioning style for the field's label.
    private var style: ControlLabelStyle = .floating

    /// Controls how read-only fields are displayed.
    public enum ReadOnlyDisplayMode: Sendable {
        /// Renders as a standard form control but non-editable.
        case control
        /// Renders as plain text without form styling.
        case plainText
        /// The appropriate display mode based on context.
        public static var automatic: Self { .control }
    }

    /// Creates a new text field with the specified label and placeholder text.
    /// - Parameters:
    ///   - label: The label text to display with the field.
    ///   - placeholder: The text to display when the field is empty.
    public init(_ label: Label, prompt: String? = nil) {
        let id = UUID().uuidString.truncatedHash
        input.attributes.id = id
        input.attributes.append(classes: "form-control")
        input.attributes.append(customAttributes: .init(name: "type", value: TextFieldTextType.text.rawValue))

        if let prompt {
            input.attributes.append(customAttributes: .init(name: "placeholder", value: prompt))
        }

        if label.isEmptyInlineElement == false {
            var label = ControlLabel(label)
            label.attributes.append(customAttributes: .init(name: "for", value: id))
            self.label = label
        }
    }

    /// Makes this field required for form submission.
    /// - Returns: A modified text field marked as required.
    public func required() -> Self {
        var copy = self
        copy.input.attributes.append(customAttributes: .required)
        return copy
    }

    /// Sets the `HTML` `id` attribute of the input, and the `for` attribute of the label.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML id added
    public func id(_ id: String) -> Self {
        var copy = self
        copy.input.attributes.id = id
        copy.label?.attributes.remove(attributesNamed: "for")
        copy.label?.attributes.append(customAttributes: .init(name: "for", value: id))
        return copy
    }

    /// Disables this field, preventing user interaction.
    /// - Returns: A modified text field in a disabled state.
    public func disabled() -> Self {
        var copy = self
        copy.input.attributes.append(customAttributes: .disabled)
        return copy
    }

    /// Makes this field read-only with a predetermined value.
    /// - Parameters:
    ///   - value: The value to display in the field.
    ///   - displayMode: How the read-only field should be presented.
    /// - Returns: A modified text field in a read-only state.
    public func readOnly(_ value: String, displayMode: ReadOnlyDisplayMode = .automatic) -> Self {
        var copy = self
        copy.input.attributes.append(customAttributes: .readOnly)
        copy.input.attributes.remove(attributesNamed: "placeholder")
        copy.input.attributes.append(customAttributes: .init(name: "value", value: value))

        if case .plainText = displayMode {
            copy.input.attributes.remove(classes: "form-control")
            copy.input.attributes.append(classes: "form-control-plaintext")
        }

        return copy
    }

    /// Sets the size of this text field.
    /// - Parameter size: The desired control size.
    /// - Returns: A modified text field with the specified size.
    public func size(_ size: ControlSize) -> Self {
        var copy = self
        copy.input.attributes.append(classes: size.controlClass)
        copy.label?.attributes.append(classes: size.labelClass)
        return copy
    }

    /// Sets the input type to control validation and keyboard appearance.
    /// - Parameter type: The type of input this field will collect.
    /// - Returns: A modified text field configured for the specified input type.
    public func type(_ type: TextFieldTextType) -> Self {
        var copy = self
        copy.input.attributes.remove(attributesNamed: "type")
        copy.input.attributes.append(customAttributes: .init(name: "type", value: type.rawValue))
        return copy
    }

    /// Sets how the label is displayed relative to the input field.
    /// - Parameter style: The style determining label placement.
    /// - Returns: A modified text field with the specified label style.
    func labelStyle(_ style: ControlLabelStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    public func render() -> Markup {
        switch style {
        case .top:
            renderTopLabeledTextField()
        case .leading:
            renderFrontLabeledTextField()
        case .floating:
            renderFloatingTextField()
        case .hidden:
            renderPlainTextField()
        }
    }

    private func renderTopLabeledTextField() -> Markup {
        Section {
            if let label {
                label.class("form-label")
            }
            input
                .attributes(attributes)
        }
        .render()
    }

    private func renderFrontLabeledTextField() -> Markup {
        Section {
            if let label {
                label.class("col-form-label col-sm-2")
            }
            Section {
                input
                    .attributes(attributes)
            }.class("col-sm-10")
        }
        .class("row")
        .render()
    }

    private func renderFloatingTextField() -> Markup {
        Section {
            input
                .attributes(attributes)
            if let label {
                label
            }
        }
        .class("form-floating")
        .render()
    }

    private func renderPlainTextField() -> Markup {
        input
            .attributes(attributes)
            .render()
    }
}

extension TextField: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        let copy = self
            .size(configuration.controlSize)
            .labelStyle(configuration.labelStyle)

        return switch configuration.labelStyle {
        case .leading: copy.render()
        default: Section(copy).render()
        }
    }
}

extension TextField: ControlGroupItemConfigurable {
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem {
        var copy = self.labelStyle(labelStyle)
        if labelStyle != .floating {
            copy.label = nil
        }
        return ControlGroupItem(copy)
    }
}
