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
            content.style(.init(.marginBottom, value: "0")) :
            Section(content.style(.init(.marginBottom, value: "0")))

        return Section(
            frameableContent
                .style(.init(.display, value: "flex"))
                .style(.init(.flexDirection, value: "column"))
                .style(.init(.position, value: "absolute"))
                .style(.init(.overflow, value: "hidden"))
                .style(edgeAlignmentRules)
                .style(alignment.flexAlignmentRules)
        )
        .style(.init(.width, value: "100%"))
        .style(.init(.height, value: "100%"))
        .style(.init(.position, value: "relative"))
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
