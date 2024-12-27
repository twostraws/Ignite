//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies dimensional constraints to HTML elements
struct FrameModifier: HTMLModifier {
    /// Represents the different types of dimensional constraints that can be applied to an element.
    private enum Dimension {
        /// The exact width, minimum width, or maximum width constraints
        case width, minWidth, maxWidth
        /// The exact height, minimum height, or maximum height constraints
        case height, minHeight, maxHeight

        /// The CSS property name for this dimension.
        var cssProperty: String {
            switch self {
            case .width: return "width"
            case .minWidth: return "min-width"
            case .maxWidth: return "max-width"
            case .height: return "height"
            case .minHeight: return "min-height"
            case .maxHeight: return "max-height"
            }
        }

        /// The Bootstrap class to use when the dimension should fill its container.
        var bootstrapClass: String {
            switch self {
            case .width, .minWidth, .maxWidth: return "w-100"
            case .height, .minHeight, .maxHeight: return "h-100"
            }
        }

        /// The Bootstrap class to use when the dimension should fill the viewport.
        var viewportClass: String {
            switch self {
            case .width, .maxWidth: return "vw-100"
            case .minWidth: return "min-vw-100"
            case .height, .maxHeight: return "vh-100"
            case .minHeight: return "min-vh-100"
            }
        }

        /// Whether this dimension requires flex alignment when using viewport sizing.
        var needsFlexAlignment: Bool {
            switch self {
            case .width, .maxWidth, .height, .maxHeight: return true
            case .minWidth, .minHeight: return false
            }
        }
    }

    private let width: LengthUnit?
    private let minWidth: LengthUnit?
    private let maxWidth: LengthUnit?
    private let height: LengthUnit?
    private let minHeight: LengthUnit?
    private let maxHeight: LengthUnit?
    private let alignment: Alignment

    init(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .center
    ) {
        self.width = width
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.height = height
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.alignment = alignment
    }

    /// Processes a single dimensional constraint and applies the appropriate styling.
    /// - Parameters:
    ///   - value: The length value to apply, if any
    ///   - dimension: The type of dimension being processed (width, height, etc.)
    ///   - classes: The collection of Bootstrap classes to append to
    ///   - modified: The HTML element being modified
    private func handleDimension(
        _ value: LengthUnit?,
        dimension: Dimension,
        classes: inout [String],
        modified: inout any HTML
    ) {
        guard let value else { return }

        switch value {
        case .vh(100), .vw(100):
            classes.append(dimension.viewportClass)
            if dimension.needsFlexAlignment {
                classes.append("d-flex")
                classes.append(contentsOf: alignment.bootstrapClasses)
            }

        case .percent(100%):
            classes.append(dimension.bootstrapClass)
            if dimension.needsFlexAlignment {
                classes.append("d-flex")
                classes.append(contentsOf: alignment.bootstrapClasses)
            }

        case .default:
            // Don't apply any styling for default values
            break

        default:
            modified = modified.style("\(dimension.cssProperty): \(value.stringValue)")
        }
    }

    func body(content: some HTML) -> any HTML {
        var modified: any HTML = content
        var classes = [String]()

        handleDimension(width, dimension: .width, classes: &classes, modified: &modified)
        handleDimension(minWidth, dimension: .minWidth, classes: &classes, modified: &modified)
        handleDimension(maxWidth, dimension: .maxWidth, classes: &classes, modified: &modified)
        handleDimension(height, dimension: .height, classes: &classes, modified: &modified)
        handleDimension(minHeight, dimension: .minHeight, classes: &classes, modified: &modified)
        handleDimension(maxHeight, dimension: .maxHeight, classes: &classes, modified: &modified)

        if alignment != .topLeading {
            classes.append(contentsOf: alignment.bootstrapClasses)
        }

        if !classes.isEmpty {
            modified = modified.class(classes.joined(separator: " "))
        }

        return modified
    }
}

public extension HTML {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - width: An exact width for this element
    ///   - minWidth: A minimum width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - height: An exact height for this element
    ///   - minHeight: A minimum height for this element
    ///   - maxHeight: A maximum height for this element
    ///   - alignment: How to align this element inside its frame
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .center
    ) -> some HTML {
        modifier(FrameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment
        ))
    }
}

public extension InlineHTML {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - width: An exact width for this element
    ///   - minWidth: A minimum width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - height: An exact height for this element
    ///   - minHeight: A minimum height for this element
    ///   - maxHeight: A maximum height for this element
    ///   - alignment: How to align this element inside its frame
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .center
    ) -> some InlineHTML {
        modifier(FrameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment
        ))
    }
}
