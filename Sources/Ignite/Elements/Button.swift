//
// Button.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls the display size of buttons. Medium is the default.
public enum ButtonSize: String, CaseIterable {
    case small, medium, large
}

/// A clickable button with a title and styling.
public struct Button: InlineElement {
    /// Whether this button is just clickable, or whether its submits a form.
    public enum ButtonType {
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

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this button should submit a form or not. Defaults to `.plain`.
    var type = ButtonType.plain

    /// How large this button should be drawn. Defaults to `.medium`.
    var size = ButtonSize.medium

    /// How this button should be styled on the screen. Defaults to `.default`.
    var role = Role.default

    /// Elements to render inside this button.
    var content: [InlineElement]

    /// Creates a button with no title. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() {
        self.content = []
    }

    /// Creates a button with a title.
    /// - Parameter title: The title text to display on this button.
    public init(_ title: InlineElement) {
        self.content = [title]
    }

    /// Creates a button from a more complex piece of HTML.
    /// - Parameter content: An inline element builder of all the content
    /// for this button.
    public init(@InlineElementBuilder content: () -> [InlineElement]) {
        self.content = content()
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

    /// Returns an array containing the correct CSS classes to style this button
    /// based on the role and size passed in. This is used for buttons, links, and
    /// dropdowns, which is why it's shared.
    /// - Parameters:
    ///   - role: The role we are styling.
    ///   - size: The size we are styling.
    /// - Returns: The CSS classes to apply for this button
    public static func classes(forRole role: Role, size: ButtonSize) -> [String] {
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

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let buttonAttributes = attributes.appending(classes: Button.classes(forRole: role, size: size))
        let output = content.map { $0.render(context: context) }.joined()
        return "<button type=\"\(type.htmlName)\"\(buttonAttributes.description)>\(output)</button>"
    }
}
