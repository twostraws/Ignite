//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies frame constraints to HTML elements.
struct FrameModifier: HTMLModifier {
    /// The minimum width constraint.
    var minWidth: LengthUnit?
    /// The exact width constraint.
    var width: LengthUnit?
    /// The maximum width constraint.
    var maxWidth: LengthUnit?
    /// The minimum height constraint.
    var minHeight: LengthUnit?
    /// The exact height constraint.
    var height: LengthUnit?
    /// The maximum height constraint.
    var maxHeight: LengthUnit?
    /// The alignment within the frame.
    var alignment: Alignment?

    func body(content: Content) -> some HTML {
        FrameModifiedHTML(
            content: content,
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight,
            alignment: alignment)
    }
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
        modifier(FrameModifier(
            minWidth: minWidth,
            width: width,
            maxWidth: maxWidth,
            minHeight: minHeight,
            height: height,
            maxHeight: maxHeight,
            alignment: alignment))
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
        modifier(FrameModifier(
            minWidth: minWidth.map { .px($0) },
            width: width.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            height: height.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some HTML {
        modifier(FrameModifier(alignment: alignment))
    }
}
