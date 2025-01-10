//
// Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies dimensional constraints to HTML elements
struct FrameModifier: HTMLModifier {
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

    init(alignment: Alignment) {
        self.width = nil
        self.minWidth = nil
        self.maxWidth = nil
        self.height = nil
        self.minHeight = nil
        self.maxHeight = nil
        self.alignment = alignment
    }

    func body(content: some HTML) -> any HTML {
        styleFrame(
            content: content,
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment)
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
        modifier(FrameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment
        ))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some HTML {
        modifier(FrameModifier(alignment: alignment))
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
    ) -> some InlineHTML {
        modifier(FrameModifier(
            width: width.map { .px($0) },
            minWidth: minWidth.map { .px($0) },
            maxWidth: maxWidth.map { .px($0) },
            height: height.map { .px($0) },
            minHeight: minHeight.map { .px($0) },
            maxHeight: maxHeight.map { .px($0) },
            alignment: alignment
        ))
    }

    /// A convenience method for setting only the alignment.
    /// - Parameter alignment: The desired alignment
    /// - Returns: A modified element with the specified alignment
    func frame(alignment: Alignment) -> some InlineHTML {
        modifier(FrameModifier(alignment: alignment))
    }
}

public extension StyledHTML {
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
    ) -> Self {
        styleFrame(
            content: self,
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment)
    }
}

// A helper method that encapsulates the frame generation logic.
@MainActor fileprivate func styleFrame<T: Modifiable>(
    content: T,
    width: LengthUnit? = nil,
    minWidth: LengthUnit? = nil,
    maxWidth: LengthUnit? = nil,
    height: LengthUnit? = nil,
    minHeight: LengthUnit? = nil,
    maxHeight: LengthUnit? = nil,
    alignment: Alignment = .center
) -> T {
    var copy = content

    if let width {
        copy.style(.init(name: .width, value: width.stringValue))
    }

    if let minWidth {
        copy.style(.init(name: .minWidth, value: minWidth.stringValue))
    }

    if let maxWidth {
        copy.style(.init(name: .maxWidth, value: maxWidth.stringValue))
    }

    if let height {
        copy.style(.init(name: .height, value: height.stringValue))
    }

    if let minHeight {
        copy.style(.init(name: .minHeight, value: minHeight.stringValue))
    }

    if let maxHeight {
        copy.style(.init(name: .maxHeight, value: maxHeight.stringValue))
    }

    copy.style(.init(name: .display, value: "flex"))
    copy.style(.init(name: .flexDirection, value: "column"))

    switch alignment.horizontal {
    case .center:
        copy.style(.init(name: .alignItems, value: "center"))
    case .leading:
        copy.style(.init(name: .alignItems, value: "start"))
    case .trailing:
        copy.style(.init(name: .alignItems, value: "end"))
    }

    switch alignment.vertical {
    case .center:
        copy.style(.init(name: .justifyContent, value: "center"))
    case .bottom:
        copy.style(.init(name: .justifyContent, value: "flex-end"))
    case .top:
        copy.style(.init(name: .justifyContent, value: "start"))
    }

    return copy
}
