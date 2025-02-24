//
// TextField.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A text input field with support for various states
public struct TextField: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The label text for the field
    var label: String?

    /// The placeholder text shown when the field is empty.
    private var placeholder: String?

    /// Whether the field must have a value before the form can be submitted.
    private var isRequired = false

    /// Whether the field is disabled and cannot be interacted with.
    private var isDisabled = false

    /// Whether the field is read-only and cannot be edited.
    private var isReadOnly = false

    /// The type of input this text field accepts.
    private var type = TextType.text

    /// The type of text field
    public enum TextType: String, CaseIterable, Sendable {
        /// Standard text input
        case text
        /// Email address input
        case email
        /// Password input
        case password
        /// Search input
        case search
        /// URL input
        case url
        /// Phone number input
        case phone
        /// Numeric input
        case number
    }

    /// Creates a new text field with the specified label and placeholder text.
    /// - Parameters:
    ///   - label: The label text to display with the field.
    ///   - placeholder: The text to display when the field is empty.
    public init(_ label: String? = nil, placeholder: String?) {
        self.label = label
        self.placeholder = placeholder
    }

    /// Makes this field required
    public func required(_ required: Bool = true) -> Self {
        var copy = self
        copy.isRequired = required
        return copy
    }

    /// Disables this field
    public func disabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Makes this field read-only
    public func readOnly(_ readOnly: Bool = true) -> Self {
        var copy = self
        copy.isReadOnly = readOnly
        return copy
    }

    /// Sets the input type (e.g., "email", "password")
    public func type(_ type: TextType) -> Self {
        var copy = self
        copy.type = type
        return copy
    }

    public func render() -> String {
        var attributes = attributes
        attributes.append(classes: "form-control")
        attributes.append(customAttributes: .init(name: "type", value: type.rawValue))

        if let placeholder {
            attributes.append(customAttributes: .init(name: "placeholder", value: placeholder))
        }

        if isRequired {
            attributes.append(customAttributes: .required)
        }

        if isDisabled {
            attributes.append(customAttributes: .disabled)
        }

        if isReadOnly {
            attributes.append(customAttributes: .readOnly)
        }

        return "<input\(attributes) />"
    }
}
