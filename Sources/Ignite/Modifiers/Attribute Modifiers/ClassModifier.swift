//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func classModifier(
    _ classNames: [String],
    content: any BodyElement
) -> any BodyElement {
    guard !classNames.filter({ !$0.isEmpty }).isEmpty else { return content }
    var copy: any BodyElement = content.isPrimitive ? content : Section(content)
    copy.attributes.append(classes: classNames)
    return copy
}

@MainActor
private func classModifier(_ classNames: [String], content: any InlineElement) -> any InlineElement {
    guard !classNames.filter({ !$0.isEmpty }).isEmpty else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.append(classes: classNames)
    return copy
}

public extension HTML {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some HTML {
        AnyHTML(classModifier([className], content: self))
    }

    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: String?...) -> some HTML {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: [String]) -> some HTML {
        AnyHTML(classModifier(newClasses, content: self))
    }
}

public extension MarkupElement where Self: InlineElement {
    /// Adds a CSS class to the HTML element
    /// - Parameter className: The CSS class name to add
    /// - Returns: A modified copy of the element with the CSS class added
    func `class`(_ className: String) -> some InlineElement {
        AnyInlineElement(classModifier([className], content: self))
    }

    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some InlineElement {
        let classes = newClasses.compactMap(\.self)
        return AnyInlineElement(classModifier(classes, content: self))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `HTML` element
    func `class`(_ newClasses: [String]) -> some InlineElement {
        AnyInlineElement(classModifier(newClasses, content: self))
    }
}

// These should always remain private, because for the
// type safety of the public facing API we always want
// to return either HTML or InlineElement.
extension BodyElement {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified `BodyElement`
    func `class`(_ newClasses: String?...) -> some BodyElement {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `BodyElement`
    func `class`(_ newClasses: [String]) -> some BodyElement {
        AnyHTML(classModifier(newClasses, content: self))
    }
}
