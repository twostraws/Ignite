//
// HorizontalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls how elements are horizontally positioned inside their container.
public enum HorizontalAlignment: String, Sendable, Equatable {
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

    /// Converts HorizontalAlignment to CSS justify-content values
    var justifyContent: String {
        switch self {
        case .leading: "flex-start"
        case .center: "center"
        case .trailing: "flex-end"
        }
    }
}

extension HorizontalAlignment: Responsive {
    public func responsiveClass(for breakpoint: String?) -> String {
        let alignmentClass = rawValue.dropFirst(5) // Remove "text-" prefix
        if let breakpoint {
            return "text-\(breakpoint)-\(alignmentClass)"
        }
        return "text-\(alignmentClass)"
    }
}

/// Determines which elements can have horizontal alignment attached,
@MainActor
public protocol HorizontalAligning: HTML { }

/// A modifier that controls horizontal alignment of HTML elements
struct HorizontalAlignmentModifier: HTMLModifier {
    /// The alignment to apply
    let alignment: ResponsiveAlignment

    init(alignment: HorizontalAlignment) {
        self.alignment = .responsive(small: alignment)
    }

    init(alignment: ResponsiveAlignment) {
        self.alignment = alignment
    }

    /// Applies horizontal alignment to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with alignment applied
    func body(content: some HTML) -> any HTML {
        let classes = alignment.breakpointClasses
        return content.class(classes)
    }
}

public extension HorizontalAligning {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> some HTML {
        modifier(HorizontalAlignmentModifier(alignment: alignment))
    }

    /// Aligns this element using multiple responsive alignments.
    /// - Parameter alignment: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignment: ResponsiveAlignment) -> some HTML {
        modifier(HorizontalAlignmentModifier(alignment: alignment))
    }
}
