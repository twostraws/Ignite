//
// SpacingType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents spacing values in either exact pixels or semantic spacing amounts.
typealias SpacingAmount = Amount<Int, SemanticSpacing>

extension SpacingAmount {
    var inlineStyle: InlineStyle? {
        switch self {
        case .exact(let value): .init(.gap, value: value.formatted())
        case .semantic(let value): .init(.gap, value: "\(Double(value.rawValue) * 0.25)em")
        default: nil
        }
    }
}
