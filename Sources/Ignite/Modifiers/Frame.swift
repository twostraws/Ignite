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
            case .width, .maxWidth: "position-relative vw-100 start-50 translate-middle-x"
            case .minWidth: "min-vw-100"
            case .height, .maxHeight: "position-absolute top-0 vh-100"
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
        alignment: Alignment = .topLeading
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
        var modified: any HTML = content
        var classes = [String]()
        var styles = [InlineStyle]()
        var requiresContainer = false

        let dimensions: [(value: LengthUnit?, dimension: Dimension)] = [
            (width, .width),
            (minWidth, .minWidth),
            (maxWidth, .maxWidth),
            (height, .height),
            (minHeight, .minHeight),
            (maxHeight, .maxHeight)
        ]

        for dimension in dimensions {
            guard let value = dimension.value else { continue }
            if dimension.value == .vh(100%) || dimension.value == .vw(100%) || dimension.value == .percent(100%) {
                handleDerivedSize(value, dimension: dimension.dimension, classes: &classes, styles: &styles)
                requiresContainer = true
            } else if dimension.value != .default {
                modified = handleExplicitSize(
                    value: value,
                    dimension: dimension.dimension,
                    content: modified)
            }
        }

        return if requiresContainer {
            Section(modified)
                .class(classes)
                .style(styles)
        } else {
            modified
        }
    }

    /// Handles percentage-based and viewport-based dimensions by applying appropriate Bootstrap classes
    /// - Parameters:
    ///   - value: The length unit to apply
    ///   - dimension: The dimension type being modified
    ///   - classes: The array of CSS classes to modify
    ///   - styles: The array of inline styles to modify
    private func handleDerivedSize(
        _ value: LengthUnit,
        dimension: Dimension,
        classes: inout [String],
        styles: inout [InlineStyle]
    ) {
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

        default: break
        }
    }

    /// Handles explicit size dimensions by applying absolute positioning and flex layout
    /// - Parameters:
    ///   - value: The length unit to apply
    ///   - dimension: The dimension type being modified
    ///   - content: The HTML content to modify
    /// - Returns: The modified HTML content
    private func handleExplicitSize(value: LengthUnit, dimension: Dimension, content: any HTML) -> any HTML {
        // When a modified element is smaller than its parent container,
        // we need to wrap it in a "framing context" that is invisible from the view hierarchy—
        // hence using ContainerAttributes instead of `Section`.
        // Using this invisible framing context means that modifiers applied after
        // frame() will respect the modified element's size—not the size of the framing context.
        var containerAttributes = content.attributes.containerAttributes
            .first(where: { $0.type == .frame }) ?? ContainerAttributes(type: .frame)

        containerAttributes.styles.append(.init(.position, value: "relative"))
        containerAttributes.styles.append(.init(.display, value: "flex"))
        containerAttributes.styles.append(.init(.flex, value: "1"))
        containerAttributes.styles.append(.init(.flexDirection, value: "column"))
        containerAttributes.styles.append(contentsOf: alignment.containerAlignmentRules)

        return content
            .style(.init(dimension.cssProperty, value: value.stringValue))
            .style(.init(.flexDirection, value: "column"))
            .style(.init(.display, value: "flex"))
            .style(.init(.position, value: "absolute"))
            .style(.init(.overflow, value: "hidden"))
            .style(alignment.edgeAlignmentRules)
            .containerAttributes(containerAttributes)
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
        alignment: Alignment = .topLeading
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
        alignment: Alignment = .topLeading
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
        alignment: Alignment = .topLeading
    ) -> some InlineElement {
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
    func frame(alignment: Alignment) -> some InlineElement {
        modifier(FrameModifier(alignment: alignment))
    }
}

fileprivate extension Alignment {
    /// The appropriate Bootstrap classes for this alignment
    var bootstrapClasses: [String] {
        [horizontal.bootstrapClass, vertical.bootstrapClass]
    }

    /// CSS positioning rules based on the horizontal and vertical alignment
    var edgeAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      [.init(.top, value: "0"), .init(.left, value: "0")]
        case (.center, .top):       [.init(.top, value: "0")]
        case (.trailing, .top):     [.init(.top, value: "0"), .init(.right, value: "0")]
        case (.leading, .center):   [.init(.left, value: "0")]
        case (.center, .center):    []
        case (.trailing, .center):  [.init(.right, value: "0")]
        case (.leading, .bottom):   [.init(.bottom, value: "0"), .init(.left, value: "0"), .init(.margin, value: "0")]
        case (.center, .bottom):    [.init(.bottom, value: "0"), .init(.margin, value: "0")]
        case (.trailing, .bottom):  [.init(.bottom, value: "0"), .init(.right, value: "0"), .init(.margin, value: "0")]
        }
    }

    /// Flex container alignment rules for centering content
    var containerAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      []
        case (.center, .top):       [.init(.alignItems, value: "center")]
        case (.trailing, .top):     []
        case (.leading, .center):   [.init(.justifyContent, value: "center")]
        case (.center, .center):    [.init(.alignItems, value: "center"), .init(.justifyContent, value: "center")]
        case (.trailing, .center):  [.init(.justifyContent, value: "center")]
        case (.leading, .bottom):   []
        case (.center, .bottom):    [.init(.alignItems, value: "center")]
        case (.trailing, .bottom):  []
        }
    }
}
