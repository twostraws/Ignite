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
    ///   - alignment: How to align this element inside its frame. When `nil`, dimensions are applied directly 
    ///     to the element. When specified, creates an invisible frame with the given dimensions
    ///     and aligns the element within it according to the alignment value.
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
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
    ///   - alignment: How to align this element inside its frame. When `nil`, dimensions are applied directly 
    ///     to the element. When specified, creates an invisible frame with the given dimensions
    ///     and aligns the element within it according to the alignment value.
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        height: Int? = nil,
        minHeight: Int? = nil,
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
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil
    ) -> some InlineElement {
        AnyHTML(frameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight))
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
    /// - Returns: A modified copy of the element with frame constraints applied
    func frame(
        width: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        height: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil
    ) -> some InlineElement {
        AnyHTML(frameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) }))
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
        alignment: Alignment? = nil
    ) -> any HTML {
        var dimensions = [InlineStyle]()

        if let minWidth {
            dimensions.append(.init(.minWidth, value: minWidth.stringValue))
        }

        if let width {
            dimensions.append(.init(.width, value: width.stringValue))
        }

        if let maxWidth {
            dimensions.append(.init(.maxWidth, value: "min(\(maxWidth.stringValue), 100%)"))
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
                self.style(alignment.itemAlignmentRules)
                    .style(self.isImage ? dimensions : [])
            }
            .style(.display, "flex")
            .style(self.isImage ? .init(.flexDirection, value: "column") : nil)
            .style(.overflow, "hidden")
            .style(alignment.flexAlignmentRules)
            .style(dimensions)
        }

        // Apply the frame to the modified element directly
        return self.style(dimensions)
    }
}
