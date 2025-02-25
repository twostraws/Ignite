//
// Attributes+Convenience.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// Convenience static properties for common HTML boolean attributes.
extension Attribute {
    /// A boolean attribute indicating that a form control is disabled.
    static let disabled: Attribute = .init("disabled")

    /// A boolean attribute indicating that a form control requires a value.
    static let required: Attribute = .init("required")

    /// A boolean attribute indicating that a form control's value cannot be modified.
    static let readOnly: Attribute = .init("readonly")

    /// A boolean attribute indicating that a form control is checked.
    static let checked: Attribute = .init("checked")

    /// A boolean attribute indicating that an option is selected.
    static let selected: Attribute = .init("selected")

    /// A boolean attribute indicating whether audio/video controls should be displayed.
    static let controls: Attribute = .init("controls")
}

// Convenience static methods for common HTML enumerated attributes.
extension Attribute {
    /// Represents the possible states for the HTML hidden attribute.
    enum HiddenState: String {
        /// Element is hidden.
        case `true`
        /// Element is visible.
        case `false`
        /// Element is hidden until found by search engine.
        case untilFound = "until-found"
    }

    /// Creates a hidden attribute with the specified state.
    /// - Parameter state: The visibility state to apply.
    /// - Returns: A new attribute configured with the hidden state.
    static func hidden(_ state: HiddenState) -> Attribute {
        Attribute(name: "hidden", value: state.rawValue)
    }
}
