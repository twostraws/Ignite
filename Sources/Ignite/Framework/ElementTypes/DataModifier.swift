//
// DataModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct DataModifier: HTMLModifier {
    let key: String
    let value: String

    func body(content: some HTML) -> any HTML {
        content.data(key, value)
    }
}

public extension HTML {
    func data(_ key: String, _ value: String) -> AttributedHTML {
        modifier(DataModifier(key: key, value: value)) as! AttributedHTML
    }
}

public extension InlineHTML {
    func data(_ key: String, _ value: String) -> AttributedHTML {
        modifier(DataModifier(key: key, value: value)) as! AttributedHTML
    }
}

public extension BlockHTML {
    func data(_ key: String, _ value: String) -> AttributedHTML {
        modifier(DataModifier(key: key, value: value)) as! AttributedHTML
    }
}
