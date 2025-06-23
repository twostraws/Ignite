//
// FormElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into forms.
/// - Warning: Do not conform to this type directly.
public protocol FormElement: BodyElement {}

public extension FormElement where Self: HTML {
    /// Generates the complete `HTML` string representation of the element.
    func render() -> Markup {
        if isPrimitive {
            body.render()
        } else {
            fatalError("This protocol is not meant to be conformed to directly.")
        }
    }
}

public extension FormElement where Self: InlineElement {
    /// Generates the complete `HTML` string representation of the element.
    func render() -> Markup {
        if isPrimitive {
            body.render()
        } else {
            fatalError("This protocol is not meant to be conformed to directly.")
        }
    }
}

// MARK: - Style Modifiers
public extension FormElement where Self: HTML {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> Self {
        var copy = self
        copy.attributes.append(styles: .init(property, value: value))
        return copy
    }
}

public extension FormElement where Self: InlineElement {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> Self {
        var copy = self
        copy.attributes.append(styles: .init(property, value: value))
        return copy
    }
}

// MARK: - Attribute Modifiers
public extension FormElement where Self: HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> Self {
        var copy = self
        copy.attributes.append(customAttributes: .init(name: name, value: value))
        return copy
    }
}

public extension FormElement where Self: InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> Self {
        var copy = self
        copy.attributes.append(customAttributes: .init(name: name, value: value))
        return copy
    }
}

 // MARK: - Data Modifiers
public extension FormElement where Self: HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> Self {
        guard !value.isEmpty else { return self }
        var copy = self
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }
}

public extension FormElement where Self: InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String) -> Self {
        guard !value.isEmpty else { return self }
        var copy = self
        copy.attributes.data.append(.init(name: name, value: value))
        return copy
    }
}

// MARK: - ID Modifiers
public extension HTML where Self: FormElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> Self {
        guard !id.isEmpty else { return self }
        var copy = self
        copy.attributes.id = id
        return copy
    }
}

public extension InlineElement where Self: FormElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> Self {
        guard !id.isEmpty else { return self }
        var copy = self
        copy.attributes.id = id
        return copy
    }
}
