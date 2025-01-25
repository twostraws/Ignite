//
// AttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct AttributeModifier: HTMLModifier {
    let name: String
    let value: String

    func body(content: some HTML) -> any HTML {
        content.customAttribute(name: name, value: value)
    }
}

public extension HTML {
    func attribute(_ name: String, _ value: String) -> some HTML {
        modifier(AttributeModifier(name: name, value: value))
    }
}

public extension InlineHTML {
    func attribute(_ name: String, _ value: String) -> some InlineHTML {
        modifier(AttributeModifier(name: name, value: value))
    }
}

public extension BlockHTML {
    func attribute(_ name: String, _ value: String) -> some BlockHTML {
        modifier(AttributeModifier(name: name, value: value))
    }
}
