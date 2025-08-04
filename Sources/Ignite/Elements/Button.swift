//
// Button.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A clickable button with a label and styling.
public struct Button<Label: InlineElement>: InlineElement, ControlGroupElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this button should submit a form or not. Defaults to `.plain`.
    private var type = ButtonType.plain

    /// How large this button should be drawn. Defaults to `.medium`.
    private var size = ButtonSize.medium

    /// How this button should be styled on the screen. Defaults to `.default`.
    private var role = Role.default

    /// Elements to render inside this button.
    private var label: Label

    /// The icon element to display before the title.
    private var systemImage: String?

    /// Whether the button is disabled and cannot be interacted with.
    private var isDisabled = false

    /// Creates a button with no label. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() where Label == EmptyInlineElement {
        self.label = EmptyInlineElement()
    }

    /// Creates a button with a label.
    /// - Parameter label: The label text to display on this button.
    public init(_ label: Label) {
        self.label = label
    }

    /// Creates a button from a more complex piece of HTML.
    /// - Parameter label: An inline element builder of all the content
    /// for this button.
    public init(@InlineElementBuilder label: () -> Label) {
        self.label = label()
    }

    /// Creates a button with a label.
    /// - Parameters:
    ///   - title: The label text to display on this button.
    ///   - systemImage: An image name chosen from https://icons.getbootstrap.com.
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    public init(
        _ title: String,
        systemImage: String? = nil,
        @ActionBuilder actions: () -> [Action] = { [] }
    ) where Label == String {
        self.label = title
        self.systemImage = systemImage
        addEvent(name: "onclick", actions: actions())
    }

    /// Creates a button with a label and actions to run when it's pressed.
    /// - Parameters:
    ///   - actions: An element builder that returns an array of actions to run when this button is pressed.
    ///   - label: The label text to display on this button.
    public init(
        @ActionBuilder actions: () -> [Action],
        @InlineElementBuilder label: () -> Label
    ) {
        self.label = label()
        addEvent(name: "onclick", actions: actions())
    }

    /// Adjusts the size of this button.
    /// - Parameter size: The new size.
    /// - Returns: A new `Button` instance with the updated size.
    public func buttonSize(_ size: ButtonSize) -> Self {
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
    public func type(_ type: ButtonType) -> Self {
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

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        var buttonAttributes = attributes
            .appending(classes: size.classes(forRole: role))
            .appending(aria: role.aria())

        if isDisabled {
            buttonAttributes.append(customAttributes: .disabled)
        }

        var labelHTML = ""
        if let systemImage, !systemImage.isEmpty {
            labelHTML = "<i class=\"bi bi-\(systemImage)\"></i> "
        }
        labelHTML += label.markupString()
        return Markup("<button type=\"\(type.htmlName)\"\(buttonAttributes)>\(labelHTML)</button>")
    }
}

extension Button: ButtonElement {}

extension Button: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        Section {
            self
                .class(configuration.controlSize.buttonClass)
                .class(configuration.labelStyle == .leading ? nil : "w-100")
        }
        .class("d-flex")
        .class(configuration.labelStyle == .floating ? "align-items-stretch" : "align-items-end")
        .render()
    }
}

extension Button: ControlGroupItemConfigurable {
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem {
        var button = self
        button.type = .plain
        return ControlGroupItem(button)
    }
}
