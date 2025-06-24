//
// SpacingType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents spacing values in either exact pixels or semantic spacing amounts.
enum SpacingAmount: Equatable {
    /// An exact spacing value in pixels.
    case exact(Int)

    /// A semantic spacing value that adapts based on context.
    case semantic(SemanticSpacing)

    /// The spacing value appropriate for the given context.
    case automatic
}
