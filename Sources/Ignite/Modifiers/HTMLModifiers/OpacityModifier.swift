//
// OpacityModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

enum OpacityType {
    case double(Double), percent(Percentage)
}

/// A modifier that applies opacity styling to HTML elements.
struct OpacityModifier: HTMLModifier {
    /// The opacity value to apply.
    var opacity: OpacityType

    func body(content: Content) -> some HTML {
        var modified = content
        let styles = Self.styles(for: opacity)
        modified.attributes.append(styles: styles)
        return modified
    }

    /// Generates CSS opacity styles for the specified opacity value.
    /// - Parameter opacity: The opacity type containing the value to apply.
    /// - Returns: An array of inline styles for opacity.
    static func styles(for opacity: OpacityType) -> [InlineStyle] {
        var styles = [InlineStyle]()
        switch opacity {
        case .double(let double) where double < 1:
            styles.append(.init(.opacity, value: double.formatted(.nonLocalizedDecimal(places: 3))))
        case .percent(let percentage) where percentage < 100%:
            styles.append(.init(.opacity, value: percentage.value.formatted(.nonLocalizedDecimal(places: 3))))
        default: break
        }
        return styles
    }
}

public extension HTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some HTML {
        modifier(OpacityModifier(opacity: .percent(value)))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Double) -> some HTML {
        modifier(OpacityModifier(opacity: .double(value)))
    }
}
