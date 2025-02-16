//
// Button.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A clickable button with a label and styling.
public struct Button: InlineElement {
    /// Controls the display size of buttons. Medium is the default.
    public enum Size: String, CaseIterable {
        case small, medium, large
    }

    /// Whether this button is just clickable, or whether its submits a form.
    public enum `Type` {
        /// This button does not submit a form.
        case plain

        /// This button submits a form.
        case submit

        /// The HTML type attribute for this button.
        var htmlName: String {
            switch self {
            case .plain: "button"
            case .submit: "submit"
            }
        }
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Whether this button should submit a form or not. Defaults to `.plain`.
    var type = Type.plain

    /// How large this button should be drawn. Defaults to `.medium`.
    var size = Size.medium

    /// How this button should be styled on the screen. Defaults to `.default`.
    var role = Role.default

    /// Elements to render inside this button.
    var label: any HTML

    /// Whether the button is disabled and cannot be interacted with.
    private var isDisabled = false

    /// Creates a button with no label. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() {
        self.label = EmptyHTML()
    }

    /// Creates a button with a label.
    /// - Parameter label: The label text to display on this button.
    public init(_ label: some InlineElement) {
        self.label = label
    }

    /// Creates a button from a more complex piece of HTML.
    /// - Parameter label: An inline element builder of all the content
    /// for this button.
    public init(@InlineHTMLBuilder label: @escaping () -> some InlineElement) {
        self.label = label()
    }

    /// Creates a button with a label.
    /// - Parameters:
    ///   - label: The label text to display on this button.
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    /// - actions: An element builder that returns an array of actions to run when this button is pressed.
    public init(_ label: String, @ActionBuilder actions: () -> [Action]) {
        self.label = label
        addEvent(name: "onclick", actions: actions())
    }

    /// Creates a button with a label and actions to run when it's pressed.
    /// - Parameters:
    ///   - label: The label text to display on this button.
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    public init(
        @InlineHTMLBuilder _ label: @escaping () -> some InlineElement,
        @ActionBuilder actions: () -> [Action]
    ) {
        self.label = label()
        addEvent(name: "onclick", actions: actions())
    }

    /// Adjusts the size of this button.
    /// - Parameter size: The new size.
    /// - Returns: A new `Button` instance with the updated size.
    public func buttonSize(_ size: Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adjusts the role of this button.
    /// - Parameter role: The new role
    /// - Returns: A new `Button` instance with the updated role.
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.role = role
        return copy
    }

    /// Sets the button type, determining its behavior.
    /// - Parameter type: The type of button, such as `.plain` or `.submit`.
    /// - Returns: A new `Button` instance with the updated type.
    public func type(_ type: Type) -> Self {
        var copy = self
        copy.type = type
        return copy
    }

    /// Disables this button.
    /// - Parameter disabled: Whether the button should be disabled.
    /// - Returns: A new `Button` instance with the updated disabled state.
    public func disabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Returns an array containing the correct CSS classes to style this button
    /// based on the role and size passed in. This is used for buttons, links, and
    /// dropdowns, which is why it's shared.
    /// - Parameters:
    ///   - role: The role we are styling.
    ///   - size: The size we are styling.
    /// - Returns: The CSS classes to apply for this button
    static func classes(forRole role: Role, size: Size) -> [String] {
        var outputClasses = ["btn"]

        switch size {
        case .small:
            outputClasses.append("btn-sm")
        case .large:
            outputClasses.append("btn-lg")
        default:
            break
        }

        switch role {
        case .default:
            break
        default:
            outputClasses.append("btn-\(role.rawValue)")
        }

        return outputClasses
    }

    /// Adds the correct ARIA attribute for Close buttons, if needed.
    static func aria(forRole role: Role) -> Attribute? {
        switch role {
        case .close:
            Attribute(name: "label", value: "Close")
        default:
            nil
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var buttonAttributes = attributes
            .appending(classes: Button.classes(forRole: role, size: size))
            .appending(aria: Button.aria(forRole: role))
        if isDisabled {
            buttonAttributes.append(customAttributes: .disabled)
        }
        let output = HTMLCollection(label).render()
        buttonAttributes.tag = "button type=\"\(type.htmlName)\""
        buttonAttributes.closingTag = "button"
        return buttonAttributes.description(wrapping: output)
    }
}

extension Button {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    public func width(_ width: Int) -> Self {
        let copy = self
        copy.columnWidth(.count(width))
        copy.class("w-100")
        return copy
    }
}
