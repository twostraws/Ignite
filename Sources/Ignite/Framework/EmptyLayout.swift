//
// EmptyLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A layout that applies almost no styling.
public struct EmptyLayout: Layout {
    public var body: some HTML {
        Body()
    }

    public init() {}
}
