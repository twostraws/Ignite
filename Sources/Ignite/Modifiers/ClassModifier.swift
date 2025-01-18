//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds CSS classes to an HTML element.
struct ClassModifier: HTMLModifier {
    let `class`: String

    func body(content: some HTML) -> any HTML {
        content._class(`class`)
    }
}

public extension HTML {
    /// Adds CSS classes to the HTML element.
    /// - Parameter name: The CSS class name.
    /// - Returns: A modified HTML element with the specified classes.
    func `class`(_ `class`: String) -> some HTML {
        modifier(ClassModifier(class: `class`))
    }
}

public extension InlineHTML {
    /// Adds CSS classes to the HTML element.
    /// - Parameter name: The CSS class name.
    /// - Returns: A modified HTML element with the specified classes.
    func `class`(_ `class`: String) -> some InlineHTML {
        modifier(ClassModifier(class: `class`))
    }
}

public extension BlockHTML {
    /// Adds CSS classes to the HTML element.
    /// - Parameter name: The CSS class name.
    /// - Returns: A modified HTML element with the specified classes.
    func `class`(_ `class`: String) -> some BlockHTML {
        modifier(ClassModifier(class: `class`))
    }
}
