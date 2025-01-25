//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct AriaModifier: HTMLModifier {
    let key: AriaType
    let value: String

    func body(content: some HTML) -> any HTML {
        content.aria(key, value)
    }
}

public extension HTML {
    func aria(_ key: AriaType, _ value: String) -> AttributedHTML {
        modifier(AriaModifier(key: key, value: value)) as! AttributedHTML
    }
}

public extension InlineHTML {
    func aria(_ key: AriaType, _ value: String) -> AttributedHTML {
        modifier(AriaModifier(key: key, value: value)) as! AttributedHTML
    }
}

public extension BlockHTML {
    func aria(_ key: AriaType, _ value: String) -> AttributedHTML {
        modifier(AriaModifier(key: key, value: value)) as! AttributedHTML
    }
}
