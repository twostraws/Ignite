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
        self.class(alignment.rawValue)
    }

    /// Aligns this element using multiple responsive alignments.
    /// - Parameter alignment: One or more alignments with optional breakpoints.
    /// - Returns: A modified copy of the element with alignments applied
    func horizontalAlignment(_ alignment: ResponsiveAlignment) -> some HTML {
        self.class(alignment.breakpointClasses)
    }
}

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
}

extension PartialResponsiveValues where Value == HorizontalAlignment {
    // Bootstrap's responsive classes automatically handle cascading behavior,
    // with a class like text-md-center applying to all larger breakpoints
    // until overridden, so our implementation removes any redundant classes
    // for larger breakpoints that share the same value as smaller ones,
    // generating only the minimum necessary classes.
    var breakpointClasses: String {
        // Get non-cascaded values, sorted by breakpoint
        let specifiedValues = values(cascaded: false).sorted(by: { $0.breakpoint < $1.breakpoint })

        // Handle the common empty case first
        guard let (firstBreakpoint, firstValue) = specifiedValues.first else {
            return ""
        }

        let baseClass = firstValue.rawValue
        let alignmentValue = baseClass.dropFirst(5)

        // If there's only one value and it's not the base value, include the infix
        guard specifiedValues.count > 1 else {
            return firstBreakpoint == .xSmall ?
                baseClass :
                "text-\(firstBreakpoint.infix!)-\(alignmentValue)"
        }

        // First breakpoint gets base class (no prefix)
        var classes = [baseClass]
        var lastValue = firstValue

        // Process remaining breakpoints
        for (breakpoint, value) in specifiedValues.dropFirst() where value != lastValue {
            let baseClass = value.rawValue
            let alignmentValue = baseClass.dropFirst(5)
            classes.append("text-\(breakpoint.infix!)-\(alignmentValue)")
            lastValue = value
        }

        return classes.joined(separator: " ")
    }
}
