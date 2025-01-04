//
// HorizontalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls how elements are horizontally positioned inside their container.
public enum HorizontalAlignment: String, Equatable, Sendable {
    /// Elements are positioned at the start of their container.
    case leading = "text-start"

    /// Elements are positioned in the center of their container.
    case center = "text-center"

    /// Elements are positioned at the end of their container.
    case trailing = "text-end"

    /// The Bootstrap class for flex alignment
    var bootstrapClass: String {
        switch self {
        case .leading: "justify-content-start"
        case .center: "justify-content-center"
        case .trailing: "justify-content-end"
        }
    }
}

extension HorizontalAlignment {
    /// Converts HorizontalAlignment to CSS justify-content values
    var justifyContent: String {
        switch self {
        case .leading: "flex-start"
        case .center: "center"
        case .trailing: "flex-end"
        }
    }
}

/// Determines which elements can have horizontal alignment attached,
public protocol HorizontalAligning: HTML { }

/// A modifier that controls horizontal alignment of HTML elements
struct HorizontalAlignmentModifier: HTMLModifier {
    /// The alignment to apply
    var alignment: HorizontalAlignment

    /// Applies horizontal alignment to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with alignment applied
    func body(content: some HTML) -> any HTML {
        content.class(alignment.rawValue)
    }
}

public extension HorizontalAligning {
    /// Aligns this element using the specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> some HTML {
        modifier(HorizontalAlignmentModifier(alignment: alignment))
    }
}
