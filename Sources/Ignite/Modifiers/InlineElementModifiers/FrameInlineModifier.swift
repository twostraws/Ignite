//
// FrameInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies frame constraints to inline elements.
///
/// Use this modifier to set width and height constraints on inline elements,
/// including minimum, maximum, and exact dimensions.
struct FrameInlineModifier: InlineElementModifier {
    /// The minimum width constraint.
    var minWidth: LengthUnit?
    /// The width constraint.
    var width: LengthUnit?
    /// The maximum width constraint.
    var maxWidth: LengthUnit?
    /// The minimum height constraint.
    var minHeight: LengthUnit?
    /// The height constraint.
    var height: LengthUnit?
    /// The maximum height constraint.
    var maxHeight: LengthUnit?

    /// Applies frame constraints to the provided content.
    /// - Parameter content: The inline element to modify.
    /// - Returns: The modified inline element with frame constraints applied.
    func body(content: Content) -> some InlineElement {
        var modified = content
        let styles = Self.styles(
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight)
        modified.attributes.append(styles: styles)
        return modified
    }

    /// Creates CSS styles for the specified frame constraints.
    /// - Parameters:
    ///   - minWidth: The minimum width constraint.
    ///   - width: The width constraint.
    ///   - maxWidth: The maximum width constraint.
    ///   - minHeight: The minimum height constraint.
    ///   - height: The height constraint.
    ///   - maxHeight: The maximum height constraint.
    /// - Returns: An array of inline styles representing the frame constraints.
    static func styles(
        minWidth: LengthUnit? = nil,
        width: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        height: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil
    ) -> [InlineStyle] {
        var dimensions = [InlineStyle]()

        if let minWidth {
            dimensions.append(.init(.minWidth, value: minWidth.stringValue))
        }

        if let width {
            dimensions.append(.init(.width, value: width.stringValue))
        }

        if let maxWidth {
            dimensions.append(.init(.maxWidth, value: maxWidth.stringValue))
        }

        if let minHeight {
            dimensions.append(.init(.minHeight, value: minHeight.stringValue))
        }

        if let height {
            dimensions.append(.init(.height, value: height.stringValue))
        }

        if let maxHeight {
            dimensions.append(.init(.maxHeight, value: maxHeight.stringValue))
        }

        return dimensions
    }
}

public extension InlineElement {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: LengthUnit? = nil,
        width: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        height: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil
    ) -> some InlineElement {
        modifier(FrameInlineModifier(
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight))
    }

    /// Creates a specific frame for this element, either using exact pixel values or
    /// using minimum/maximum pixel ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: Int? = nil,
        width: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        height: Int? = nil,
        maxHeight: Int? = nil
    ) -> some InlineElement {
        modifier(FrameInlineModifier(
            minWidth: minWidth.map { .px($0) },
            width: width.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            height: height.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) }))
    }
}

public extension NavigationElement {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: LengthUnit? = nil,
        width: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        height: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil
    ) -> Self {
        let dimensionStyles = FrameInlineModifier.styles(
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight)
        var modified = self
        modified.attributes.append(styles: dimensionStyles)
        return modified
    }

    /// Creates a specific frame for this element, either using exact pixel values or
    /// using minimum/maximum pixel ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: Int? = nil,
        width: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        height: Int? = nil,
        maxHeight: Int? = nil
    ) -> Self {
        let dimensionStyles = FrameInlineModifier.styles(
            minWidth: minWidth.map { .px($0) },
            width: width.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            height: height.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) })
        var modified = self
        modified.attributes.append(styles: dimensionStyles)
        return modified
    }
}

public extension StyledHTML {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: LengthUnit? = nil,
        width: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        height: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil
    ) -> Self {
        let dimensionStyles = FrameInlineModifier.styles(
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight)
        return self.style(dimensionStyles)
    }
}
