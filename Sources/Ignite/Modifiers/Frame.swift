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
        alignment: Alignment = .center
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
        alignment: Alignment = .center
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
        alignment: Alignment = .center
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
        alignment: Alignment = .center
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

private extension HTML {
    func frameModifier(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .center
    ) -> any HTML {
        var dimensions = [InlineStyle]()

        if let minWidth, minWidth != .default {
            dimensions.append(.init(.minWidth, value: minWidth.stringValue))
        }

        if let width, width != .default {
            dimensions.append(.init(.width, value: width.stringValue))
        }

        if let maxWidth, maxWidth != .default {
            dimensions.append(.init(.maxWidth, value: "min(\(maxWidth.stringValue), 100%)"))
        }

        if let minHeight, minHeight != .default {
            dimensions.append(.init(.minHeight, value: minHeight.stringValue))
        }

        if let height, height != .default {
            dimensions.append(.init(.height, value: height.stringValue))
        }

        if let maxHeight, maxHeight != .default {
            dimensions.append(.init(.maxHeight, value: maxHeight.stringValue))
        }

        var content: any HTML = self

        if self.isImage {
            // Images won't size based on the height of their parent container,
            // so we need to explicitly set the dimensions of the image as well
            if let anyHTML = self as? AnyHTML, var container = anyHTML.attributedContent as? Container {
                var image = container.wrapped
                image = image.style(dimensions)
                container.wrapped = image
                content = container
            } else {
                content = content.style(dimensions)
            }
        } else {
            if self.isContainedImage {
                content = content.style(.marginBottom, "0")
            } else {
                content = content.style(dimensions).style(.marginBottom, "0")
            }
        }

        // Ensure we have a parent div to act as a positioning context
        return Container(content)
            .style(.display, "flex")
            .style(.flexDirection, "column")
            .style(.overflow, "hidden")
            .style(alignment.flexAlignmentRules)
            .style(dimensions)
    }
}

extension HTML {
    var isImage: Bool {
        self is Image ||
        (self as? AnyHTML)?.wrapped is Image
    }

    var isContainedImage: Bool {
        ((self as? AnyHTML)?.wrapped as? Container)?.wrapped is Image
    }
}
