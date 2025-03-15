//
// HorizontalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Determines which elements can have horizontal alignment attached,
@MainActor
public protocol HorizontalAligning: HTML {}

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
    func horizontalAlignment(_ alignment: HorizontalAlignment.ResponsiveAlignment) -> some HTML {
        self.class(alignment.containerAlignmentClasses)
    }
}

public extension StyledHTML {
    /// Aligns this element using a specific alignment.
    /// - Parameter alignment: How to align this element.
    /// - Returns: A modified copy of the element with alignment applied
    func horizontalAlignment(_ alignment: HorizontalAlignment) -> Self {
        style(alignment.itemAlignmentStyle)
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

    /// The Bootstrap class for flex justify-content alignment
    var flexAlignmentClass: String {
        switch self {
        case .leading: "justify-content-start"
        case .center: "justify-content-center"
        case .trailing: "justify-content-end"
        }
    }

    var containerAlignmentStyle: InlineStyle {
        switch self {
        case .leading: .init(.textAlign, value: "left")
        case .center: .init(.textAlign, value: "center")
        case .trailing: .init(.textAlign, value: "right")
        }
    }

    var itemAlignmentStyle: InlineStyle {
        switch self {
        case .leading: .init(.alignSelf, value: "start")
        case .center: .init(.alignSelf, value: "center")
        case .trailing: .init(.alignSelf, value: "end")
        }
    }
}

public extension HorizontalAlignment {
    struct ResponsiveAlignment: Equatable {
        /// The responsive values for different breakpoints
        var values: ResponsiveValues<HorizontalAlignment>

        /// Creates a responsive value that adapts across different screen sizes.
        /// - Parameters:
        ///   - xSmall: The base value, applied to all breakpoints unless overridden.
        ///   - small: Value for small screens and up. If `nil`, inherits from smaller breakpoints.
        ///   - medium: Value for medium screens and up. If `nil`, inherits from smaller breakpoints.
        ///   - large: Value for large screens and up. If `nil`, inherits from smaller breakpoints.
        ///   - xLarge: Value for extra large screens and up. If `nil`, inherits from smaller breakpoints.
        ///   - xxLarge: Value for extra extra large screens and up. If `nil`, inherits from smaller breakpoints.
        /// - Returns: A responsive alignment that adapts to different screen sizes.
        public static func responsive(
            _ xSmall: HorizontalAlignment? = nil,
            small: HorizontalAlignment? = nil,
            medium: HorizontalAlignment? = nil,
            large: HorizontalAlignment? = nil,
            xLarge: HorizontalAlignment? = nil,
            xxLarge: HorizontalAlignment? = nil
        ) -> ResponsiveAlignment {
            ResponsiveAlignment(
                values: ResponsiveValues(
                    xSmall,
                    small: small,
                    medium: medium,
                    large: large,
                    xLarge: xLarge,
                    xxLarge: xxLarge
                )
            )
        }

        /// Generates responsive CSS class strings based on the provided prefix and breakpoint values.
        /// - Parameter prefix: The CSS class prefix (e.g., "text" or "align-self")
        /// - Returns: A space-separated string of CSS classes for responsive behavior
        private func generateResponsiveClasses(prefix: String) -> String {
            // Bootstrap's responsive classes automatically handle cascading behavior,
            // with a class like text-md-center applying to all larger breakpoints
            // until overridden, so our implementation removes any redundant classes
            // for larger breakpoints that share the same value as smaller ones,
            // generating only the minimum necessary classes.
            let specifiedValues = values.values(cascaded: false)

            // Handle the common empty case first
            guard let firstElement = specifiedValues.elements.first else {
                return ""
            }

            let firstBreakpoint = firstElement.key
            let firstValue = firstElement.value

            // Extract the alignment value directly from the rawValue
            let alignmentValue = firstValue.rawValue.dropFirst(5)
            let baseClass = "\(prefix)-\(alignmentValue)"

            // If there's only one value and it's not the base value, include the infix
            guard specifiedValues.count > 1 else {
                return firstBreakpoint == .xSmall ?
                    baseClass :
                    "\(prefix)-\(firstBreakpoint.infix!)-\(alignmentValue)"
            }

            // First breakpoint gets base class (no prefix)
            var classes = [baseClass]
            var lastValue = firstValue

            // Process remaining breakpoints
            for element in specifiedValues.elements.dropFirst() where element.value != lastValue {
                let alignmentValue = element.value.rawValue.dropFirst(5)
                classes.append("\(prefix)-\(element.key.infix!)-\(alignmentValue)")
                lastValue = element.value
            }

            return classes.joined(separator: " ")
        }

        /// Bootstrap classes for responsive text alignment of content within containers
        var containerAlignmentClasses: String {
            generateResponsiveClasses(prefix: "text")
        }

        /// Bootstrap classes for responsive self-alignment of items within flex containers
        var itemAlignmentClasses: String {
            generateResponsiveClasses(prefix: "align-self")
        }
    }
}
