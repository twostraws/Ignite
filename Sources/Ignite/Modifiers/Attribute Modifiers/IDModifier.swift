//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func idModifier(_ id: String) -> any HTML {
        guard !id.isEmpty else { return self }
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.id = id
        return copy
    }
}

public extension HTML {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML id added
    func id(_ id: String) -> some HTML {
        AnyHTML(idModifier(id))
    }
}

public extension InlineElement {
    /// Sets the `HTML` id attribute of the element.
    /// - Parameter id: The HTML ID value to set
    /// - Returns: A modified copy of the element with the HTML ID added
    func id(_ id: String) -> some InlineElement {
        AnyHTML(idModifier(id))
    }
}
