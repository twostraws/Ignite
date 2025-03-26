//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func classModifier(classNames: [String]) -> any HTML {
        guard !classNames.filter({ !$0.isEmpty }).isEmpty else { return self }
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.append(classes: classNames)
        return copy
    }
}

public extension HTML {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some HTML {
        AnyHTML(classModifier(classNames: [className]))
    }
}

public extension InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some InlineElement {
        AnyHTML(classModifier(classNames: [className]))
    }
}

public extension HTML {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some HTML {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classNames: classes))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: [String]) -> some HTML {
        return AnyHTML(classModifier(classNames: newClasses))
    }
}

public extension InlineElement {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some InlineElement {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classNames: classes))
    }
}
