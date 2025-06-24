//
// Amount.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

enum Amount<Exact: Sendable, Semantic: Sendable>: Sendable {
    /// An exact value in pixels.
    case exact(Exact)

    /// A semantic value that adapts based on context.
    case semantic(Semantic)

    /// The value appropriate for the given context.
    case automatic
}
