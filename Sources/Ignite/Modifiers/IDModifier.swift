//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that sets the HTML element's ID attribute.
struct IDModifier: HTMLModifier {
    let id: String

    func body(content: some HTML) -> any HTML {
        content._id(id)
    }
}

public extension HTML {
    /// Sets the ID of the HTML element.
    /// - Parameter id: The unique identifier for the element.
    /// - Returns: A modified HTML element with the specified ID.
    func id(_ id: String) -> some HTML {
        modifier(IDModifier(id: id))
    }
}

public extension InlineHTML {
    /// Sets the ID of the inline HTML element.
    /// - Parameter id: The unique identifier for the element.
    /// - Returns: A modified HTML element with the specified ID.
    func id(_ id: String) -> some InlineHTML {
        modifier(IDModifier(id: id))
    }
}

public extension HTML where Self: BlockHTML {
    /// Sets the ID of the block HTML element.
    /// - Parameter id: The unique identifier for the element.
    /// - Returns: A modified HTML element with the specified ID.
    func id(_ id: String) -> some BlockHTML {
        modifier(IDModifier(id: id))
    }
}
