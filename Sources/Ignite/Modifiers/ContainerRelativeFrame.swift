//
// ContainerRelativeFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that creates a flex container with horizontal alignment
struct ContainerRelativeFrameModifier: HTMLModifier {
    /// The alignment to apply to the container
    var alignment: Alignment

    private let edgeAlignmentRules: [InlineStyle] = [
        .init(.top, value: "0"),
        .init(.right, value: "0"),
        .init(.bottom, value: "0"),
        .init(.left, value: "0"),
    ]

    /// Creates a flex container around the provided content with specified alignment
    /// - Parameter content: The HTML element to wrap in a flex container
    /// - Returns: A Group containing the content with flex display and alignment applied
    func body(content: some HTML) -> any HTML {
        let frameableContent: any HTML = content.attributes.tag == "div" ?
            content.style(.marginBottom, "0") :
            Section(content.style(.marginBottom, "0"))

        return Section(
            frameableContent
                .style(.display, "flex")
                .style(.flexDirection, "column")
                .style(.position, "absolute")
                .style(.overflow, "hidden")
                .style(edgeAlignmentRules)
                .style(alignment.flexAlignmentRules)
        )
        .style(.width, "100%")
        .style(.height, "100%")
        .style(.position, "relative")
    }
}

public extension HTML {
    /// Creates a flex container that allows its child to be positioned relative to its container.
    /// - Parameter alignment: How to align the content within the container. Default is `.center`.
    /// - Returns: A modified copy of the element with container-relative positioning applied.
    func containerRelativeFrame(_ alignment: Alignment = .center) -> some HTML {
        modifier(ContainerRelativeFrameModifier(alignment: alignment))
    }
}

fileprivate extension Alignment {
    /// Flex container rules for aligning content
    var flexAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-start")]
        case (.center, .top):       [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-start")]
        case (.trailing, .top):     [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-start")]
        case (.leading, .center):   [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "center")]
        case (.center, .center):    [.init(.alignItems, value: "center"), .init(.justifyContent, value: "center")]
        case (.trailing, .center):  [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "center")]
        case (.leading, .bottom):   [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-end")]
        case (.center, .bottom):    [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-end")]
        case (.trailing, .bottom):  [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-end")]
        }
    }
}
