//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct InlineStyleModifier: HTMLModifier {
    let property: Property
    let value: String

    func body(content: some HTML) -> any HTML {
        content.style(property, value)
    }
}

public extension HTML {
    @discardableResult func style(_ property: Property, _ value: String) -> AttributedHTML {
        modifier(InlineStyleModifier(property: property, value: value)) as! AttributedHTML
    }
}

public extension InlineHTML {
    @discardableResult func style(_ property: Property, _ value: String) -> AttributedHTML {
        modifier(InlineStyleModifier(property: property, value: value)) as! AttributedHTML
    }
}

public extension BlockHTML {
    @discardableResult func style(_ property: Property, _ value: String) -> AttributedHTML {
        modifier(InlineStyleModifier(property: property, value: value)) as! AttributedHTML
    }
}
