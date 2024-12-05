//
// TextField.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A text input field with support for various states
public struct TextField: InlineHTML, BlockHTML {
    /// How many columns this should occupy when placed in a section or form.
    public var columnWidth: ColumnWidth = .automatic

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The placeholder text shown when the field is empty.
    private var placeholder: String

    /// Whether the field must have a value before the form can be submitted.
    private var isRequired = false

    /// The type of input this text field accepts.
    private var type = TextType.text

    /// The type of text field
    public enum TextType: String {
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

    /// Creates a new text field with the specified placeholder text.
    /// - Parameter placeholder: The text to display when the field is empty.
    public init(_ placeholder: String) {
        self.placeholder = placeholder
    }

    /// Makes this field required
    public func required(_ required: Bool = true) -> Self {
        var copy = self
        copy.isRequired = required
        return copy
    }

    /// Sets the input type (e.g., "email", "password")
    public func type(_ type: TextType) -> Self {
        var copy = self
        copy.type = type
        return copy
    }

    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.selfClosingTag = "input"
        attributes.classes.append("form-control")
        attributes.customAttributes.insert(.init(name: "type", value: type.rawValue))
        attributes.customAttributes.insert(.init(name: "placeholder", value: placeholder))

        if isRequired {
            attributes.customAttributes.insert(.init(name: "required", value: ""))
        }

        return attributes.description()
    }
}

