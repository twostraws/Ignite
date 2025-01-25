//
// IDModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct IDModifier: HTMLModifier {
    let id: String

    func body(content: some HTML) -> any HTML {
        content.id(id)
    }
}

public extension HTML {
    func id(_ id: String) -> AttributedHTML {
        modifier(IDModifier(id: id)) as! AttributedHTML
    }
}

public extension InlineHTML {
    func id(_ id: String) -> AttributedHTML {
        modifier(IDModifier(id: id)) as! AttributedHTML
    }
}

public extension BlockHTML {
    func id(_ id: String) -> AttributedHTML {
        modifier(IDModifier(id: id)) as! AttributedHTML
    }
}
