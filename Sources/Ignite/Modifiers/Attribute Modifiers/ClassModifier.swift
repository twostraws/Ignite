//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func classModifier(
    _ classNames: [String],
    content: any RenderableElement
) -> any RenderableElement {
    guard !classNames.filter({ !$0.isEmpty }).isEmpty else { return content }
    var copy: any RenderableElement = content.isPrimitive ? content : Section(content)
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
    /// - Returns: The modified Element element
    func `class`(_ newClasses: String?...) -> some HTML {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `Element` element
    func `class`(_ newClasses: [String]) -> some HTML {
        AnyHTML(classModifier(newClasses, content: self))
    }
}

public extension RenderableElement where Self: InlineElement {
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
    /// - Returns: The modified `Element` element
    func `class`(_ newClasses: [String]) -> some InlineElement {
        AnyInlineElement(classModifier(newClasses, content: self))
    }
}

public extension FormItem {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified HTML element
    func `class`(_ newClasses: String?...) -> some FormItem {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }
}

public extension FormItem where Self: InlineElement {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified Element element
    func `class`(_ newClasses: String?...) -> some FormItem {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }
}

// These should always remain private, because for the
// type safety of the public facing API we always want
// to return either Element or InlineElement.
extension RenderableElement {
    /// Adds multiple optional CSS classes to the element.
    /// - Parameter newClasses: Variable number of optional class names
    /// - Returns: The modified Element element
    func `class`(_ newClasses: String?...) -> some RenderableElement {
        let classes = newClasses.compactMap(\.self)
        return AnyHTML(classModifier(classes, content: self))
    }

    /// Adds an array of CSS classes to the element.
    /// - Parameter newClasses: `Array` of class names to add
    /// - Returns: The modified `Element` element
    func `class`(_ newClasses: [String]) -> some RenderableElement {
        AnyHTML(classModifier(newClasses, content: self))
    }
}
