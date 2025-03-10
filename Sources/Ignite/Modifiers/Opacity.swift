//
// Opacity.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Percentage) -> some HTML {
        AnyHTML(opacityModifier(.percent(value)))
    }

    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0 (fully transparent) and 1.0 (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ value: Double) -> some HTML {
        AnyHTML(opacityModifier(.double(value)))
    }
}

public extension StyledHTML {
    /// Adjusts the opacity of an element.
    /// - Parameter value: A value between 0% (fully transparent) and 100% (fully opaque).
    /// - Returns: A modified copy of the element with opacity applied
    func opacity(_ percentage: Percentage) -> Self {
        self.style(.opacity, String(percentage.value))
    }
}

private enum OpacityType {
    case double(Double), percent(Percentage)
}

private extension HTML {
    func opacityModifier(_ opacity: OpacityType) -> any HTML {
        switch opacity {
        case .double(let double) where double < 1:
            self.style(.opacity, double.formatted(.nonLocalizedDecimal(places: 3)))
        case .percent(let percentage) where percentage < 100%:
            self.style(.opacity, percentage.value.formatted(.nonLocalizedDecimal(places: 3)))
        default:
            self
        }
    }
}
