//
// ClassModifier-Internal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension HTML {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some HTML {
        let compacted = newClasses.compactMap(\.self)
        return modifier(ClassModifier(classNames: compacted))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: [String]) -> some HTML {
        return modifier(ClassModifier(classNames: newClasses))
    }
}

extension InlineElement {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some InlineElement {
        let compacted = newClasses.compactMap(\.self)
        return modifier(ClassModifier(classNames: compacted))
    }
}
