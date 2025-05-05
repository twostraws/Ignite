//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// Specialized method for block page elements.
@MainActor private func frameModifier(
    width: LengthUnit? = nil,
    minWidth: LengthUnit? = nil,
    maxWidth: LengthUnit? = nil,
    height: LengthUnit? = nil,
    minHeight: LengthUnit? = nil,
    maxHeight: LengthUnit? = nil,
    alignment: Alignment? = nil,
    content: some HTML
) -> any HTML {
    var dimensions = [InlineStyle]()

    if let minWidth {
        dimensions.append(.init(.minWidth, value: minWidth.stringValue))
    }

    if let width {
        dimensions.append(.init(.width, value: width.stringValue))
    }

    if let maxWidth {
        if width == nil {
            // If no width has been explicitly set, allow content
            // to scale with screen sizes smaller than the max width
            // as a sensible default
            dimensions.append(.init(.width, value: "100%"))
        }
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

    if let alignment {
        // Create a positioning context with the specified frame for the modified element
        return Section {
            content
                .style(alignment.itemAlignmentRules)
                .style(content.is(Image.self) ? dimensions : [])
        }
        .style(.display, "flex")
        .style(content.is(Image.self) ? .init(.flexDirection, value: "column") : nil)
        .style(.overflow, "hidden")
        .style(alignment.flexAlignmentRules)
        .style(dimensions)
    }

    // Apply the frame to the modified element directly
    return content.style(dimensions)
}

@MainActor func frameModifier(
    width: LengthUnit? = nil,
    minWidth: LengthUnit? = nil,
    maxWidth: LengthUnit? = nil,
    height: LengthUnit? = nil,
    minHeight: LengthUnit? = nil,
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

public extension HTML {
    /// Creates a specific frame for this element, either using exact values or
    /// using minimum/maximum ranges.
    /// - Parameters:
    ///   - minWidth: A minimum width for this element
    ///   - width: An exact width for this element
    ///   - maxWidth: A maximum width for this element
    ///   - minHeight: A minimum height for this element
    ///   - height: An exact height for this element
    ///   - maxHeight: A maximum height for this element
    ///   - alignment: How to align this element inside its frame. When `nil`, dimensions are applied directly
    ///     to the element. When specified, creates an invisible frame with the given dimensions
    ///     and aligns the element within it according to the alignment value.
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: LengthUnit? = nil,
        width: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        height: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment? = nil
    ) -> some HTML {
        AnyHTML(frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment,
            content: self))
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
    ///   - alignment: How to align this element inside its frame. When `nil`, dimensions are applied directly
    ///     to the element. When specified, creates an invisible frame with the given dimensions
    ///     and aligns the element within it according to the alignment value.
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        minWidth: Int? = nil,
        width: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        height: Int? = nil,
        maxHeight: Int? = nil,
        alignment: Alignment? = nil
    ) -> some HTML {
        AnyHTML(frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment,
            content: self))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some HTML {
        AnyHTML(frameModifier(alignment: alignment, content: self))
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
        let dimensionStyles = frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight)
        return self.style(dimensionStyles)
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
        let dimensionStyles = frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) })
        return self.style(dimensionStyles)
    }
}

public extension NavigationItem {
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
        let dimensionStyles = frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight)
        return self.style(dimensionStyles)
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
        let dimensionStyles = frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) })
        return self.style(dimensionStyles)
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
        let dimensionStyles = frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight)
        return self.style(dimensionStyles)
    }
}
