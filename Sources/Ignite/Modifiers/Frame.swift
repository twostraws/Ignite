//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
        alignment: Alignment = .topLeading
    ) -> some HTML {
        AnyHTML(frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment))
    }

    /// Creates a specific frame for this element, either using exact pixel values or
    /// using minimum/maximum pixel ranges.
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
        width: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        height: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil,
        alignment: Alignment = .topLeading
    ) -> some HTML {
        AnyHTML(frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some HTML {
        AnyHTML(frameModifier(alignment: alignment))
    }
}

public extension InlineElement {
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
        alignment: Alignment = .topLeading
    ) -> some InlineElement {
        AnyHTML(frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment))
    }

    /// Creates a specific frame for this element, either using exact pixel values or
    /// using minimum/maximum pixel ranges.
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
        width: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        height: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil,
        alignment: Alignment = .topLeading
    ) -> some InlineElement {
        AnyHTML(frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some InlineElement {
        AnyHTML(frameModifier(alignment: alignment))
    }
}

/// Represents the different types of dimensional constraints that can be applied to an element.
private enum Dimension {
    /// The exact width, minimum width, or maximum width constraints
    case width, minWidth, maxWidth
    /// The exact height, minimum height, or maximum height constraints
    case height, minHeight, maxHeight

    /// The CSS property name for this dimension.
    var cssProperty: Property {
        switch self {
        case .width: .width
        case .minWidth: .minWidth
        case .maxWidth: .maxWidth
        case .height: .height
        case .minHeight: .minHeight
        case .maxHeight: .maxHeight
        }
    }

    /// The Bootstrap class to use when the dimension should fill its container.
    var bootstrapClass: String {
        switch self {
        case .width, .minWidth, .maxWidth: "w-100"
        case .height, .minHeight, .maxHeight: "h-100"
        }
    }

    /// The Bootstrap class to use when the dimension should fill the viewport.
    var viewportClass: String {
        switch self {
        case .width, .maxWidth: "vw-100"
        case .minWidth: "min-vw-100"
        case .height, .maxHeight: "vh-100"
        case .minHeight: "min-vh-100"
        }
    }

    /// Whether this dimension requires flex alignment when using viewport sizing.
    var needsFlexAlignment: Bool {
        switch self {
        case .width, .maxWidth, .height, .maxHeight: true
        case .minWidth, .minHeight: false
        }
    }
}

private extension HTML {
    func frameModifier(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .topLeading
    ) -> any HTML {
        var modified: any HTML = self
        var classes = [String]()

        handleDimension(width, dimension: .width, alignment: alignment, classes: &classes, modified: &modified)
        handleDimension(minWidth, dimension: .minWidth, alignment: alignment, classes: &classes, modified: &modified)
        handleDimension(maxWidth, dimension: .maxWidth, alignment: alignment, classes: &classes, modified: &modified)
        handleDimension(height, dimension: .height, alignment: alignment, classes: &classes, modified: &modified)
        handleDimension(minHeight, dimension: .minHeight, alignment: alignment, classes: &classes, modified: &modified)
        handleDimension(maxHeight, dimension: .maxHeight, alignment: alignment, classes: &classes, modified: &modified)

        if alignment != .topLeading {
            classes.append(contentsOf: alignment.bootstrapClasses)
        }

        if !classes.isEmpty {
            modified = modified.class(classes.joined(separator: " "))
        }

        return modified
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
        alignment: Alignment,
        classes: inout [String],
        modified: inout any HTML
    ) {
        guard let value else { return }

        switch value {
        case .vh(100%), .vw(100%):
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

        case .custom(let value):
            modified.attributes.append(styles: .init(dimension.cssProperty, value: value))

        case value where dimension == .maxWidth || dimension == .width:
            // For max-width and width, ensure all units are responsive
            modified.attributes.append(styles: .init(dimension.cssProperty, value: "min(\(value.stringValue), 100%)"))

        default:
            // For other dimensions, use the original value
            modified.attributes.append(styles: .init(dimension.cssProperty, value: value.stringValue))
        }
    }
}
