//
// ContainerRelativeFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Creates a flex container that allows its child to be positioned relative to its container.
    /// - Parameter alignment: How to align the content within the container. Default is `.center`.
    /// - Returns: A modified copy of the element with container-relative positioning applied.
    func containerRelativeFrame(_ alignment: Alignment = .center) -> some HTML {
        AnyHTML(containerRelativeFrameModifer(alignment))
    }
}

private let edgeAlignmentRules: [InlineStyle] = [
    .init(.top, value: "0"),
    .init(.right, value: "0"),
    .init(.bottom, value: "0"),
    .init(.left, value: "0")
]

private extension HTML {
    func containerRelativeFrameModifer(_ alignment: Alignment) -> any HTML {
        let frameableContent: any HTML = self is Section ?
            self.style(.marginBottom, "0") :
            Section(self.style(.marginBottom, "0"))

        return frameableContent
            .style(.display, "flex")
            .style(.flexDirection, "column")
            .style(.position, "absolute")
            .style(.overflow, "hidden")
            .style(edgeAlignmentRules)
            .style(alignment.flexAlignmentRules)
            .style(.width, "100%")
            .style(.height, "100%")
            .style(.position, "relative")
    }
}

private extension Alignment {
    /// Flex container rules for aligning content
    var flexAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-start")]
        case (.center, .top): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-start")]
        case (.trailing, .top): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-start")]
        case (.leading, .center): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "center")]
        case (.center, .center): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "center")]
        case (.trailing, .center): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "center")]
        case (.leading, .bottom): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-end")]
        case (.center, .bottom): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-end")]
        case (.trailing, .bottom): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-end")]
        }
    }
}
