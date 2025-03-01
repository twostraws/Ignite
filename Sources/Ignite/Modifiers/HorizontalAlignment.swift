//
// HorizontalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Determines which elements can have horizontal alignment attached,
@MainActor
public protocol HorizontalAligning: HTML { }

public extension HorizontalAligning {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> some HTML {
        self.class(ResponsiveAlignment.responsive(small: alignment).breakpointClasses)
    }

    /// Aligns this element using multiple responsive alignments.
    /// - Parameter alignment: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignment: ResponsiveAlignment) -> some HTML {
        self.class(alignment.breakpointClasses)
    }
}

/// Controls how elements are horizontally positioned inside their container.
public enum HorizontalAlignment: String, Sendable, Equatable, Responsive {
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

    func responsiveClass(for breakpoint: Breakpoint) -> String {
        let alignmentClass = rawValue.dropFirst(5) // Remove "text-" prefix
        return "text-\(breakpoint)-\(alignmentClass)"
    }
}
