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
        case .leading: return "justify-content-start"
        case .center: return "justify-content-center"
        case .trailing: return "justify-content-end"
        }
    }

    /// Converts HorizontalAlignment to CSS justify-content values
    var justifyContent: String {
        switch self {
        case .leading: return "flex-start"
        case .center: return "center"
        case .trailing: return "flex-end"
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
public protocol HorizontalAligning: HTML { }

/// A modifier that controls horizontal alignment of HTML elements
struct HorizontalAlignmentModifier: HTMLModifier {
    /// The alignment to apply
    let alignments: [ResponsiveAlignment]

    init(alignment: HorizontalAlignment) {
        self.alignments = [.small(alignment)]
    }

    init(alignments: [ResponsiveAlignment]) {
        self.alignments = alignments
    }

    /// Applies horizontal alignment to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with alignment applied
    func body(content: some HTML) -> any HTML {
        let classes = alignments
            .map(\.breakpointClass)
            .joined(separator: " ")
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
    /// - Parameter alignments: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignments: ResponsiveAlignment...) -> some HTML {
        modifier(HorizontalAlignmentModifier(alignments: alignments))
    }
}
