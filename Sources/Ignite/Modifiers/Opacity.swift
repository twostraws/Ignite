//
// Opacity.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

private enum OpacityType {
    case double(Double), percent(Percentage)
}

@MainActor private func opacityModifier(
    _ opacity: OpacityType,
    content: any HTML
) -> any HTML {
    switch opacity {
    case .double(let double) where double < 1:
        content.style(.opacity, double.formatted(.nonLocalizedDecimal(places: 3)))
    case .percent(let percentage) where percentage < 100%:
        content.style(.opacity, percentage.value.formatted(.nonLocalizedDecimal(places: 3)))
    default:
        content
    }
}

@MainActor private func opacityModifier(
    _ opacity: OpacityType,
    content: any InlineElement
) -> any InlineElement {
    switch opacity {
    case .double(let double) where double < 1:
        content.style(.opacity, double.formatted(.nonLocalizedDecimal(places: 3)))
    case .percent(let percentage) where percentage < 100%:
        content.style(.opacity, percentage.value.formatted(.nonLocalizedDecimal(places: 3)))
    default:
        content
    }
}

public extension HTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some HTML {
        AnyHTML(opacityModifier(.percent(value), content: self))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Double) -> some HTML {
        AnyHTML(opacityModifier(.double(value), content: self))
    }
}

public extension InlineElement {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some InlineElement {
        AnyInlineElement(opacityModifier(.percent(value), content: self))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Double) -> some InlineElement {
        AnyInlineElement(opacityModifier(.double(value), content: self))
    }
}

public extension StyledHTML {
    /// Adjusts the opacity of an element.
    /// - Parameter percentage: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ percentage: Percentage) -> Self {
        self.style(.opacity, String(percentage.value))
    }
}
