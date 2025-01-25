//
// ClassModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct ClassModifier: HTMLModifier {
    let classes: [String]

    func body(content: some HTML) -> any HTML {
        content.class(classes)
    }
}

public extension HTML {
    @discardableResult func `class`(_ classes: String...) -> AttributedHTML {
        modifier(ClassModifier(classes: classes)) as! AttributedHTML
    }
}

public extension InlineHTML {
    @discardableResult func `class`(_ classes: String...) -> AttributedHTML {
        modifier(ClassModifier(classes: classes)) as! AttributedHTML
    }
}

public extension BlockHTML {
    @discardableResult func `class`(_ classes: String...) -> AttributedHTML {
        modifier(ClassModifier(classes: classes)) as! AttributedHTML
    }
}
