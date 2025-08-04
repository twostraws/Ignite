//
// ClassInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct ClassInlineModifier: InlineElementModifier {
    var classNames: [String]
    func body(content: Content) -> some InlineElement {
        var content = content
        let safeClasses = classNames.filter({ !$0.isEmpty })
        content.attributes.append(classes: safeClasses)
        return content
    }
}

public extension InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some InlineElement {
        modifier(ClassInlineModifier(classNames: [className]))
    }

    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some InlineElement {
        let classes = newClasses.compactMap(\.self)
        return modifier(ClassInlineModifier(classNames: classes))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: [String]) -> some InlineElement {
        modifier(ClassInlineModifier(classNames: newClasses))
    }
}
