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
        var frameableContent: any HTML = self
            .style(.marginBottom, "0")
            .style(alignment.itemAlignmentRules)

        frameableContent = if self is Section {
            frameableContent
        } else {
            Section(frameableContent)
        }

        return frameableContent
            .style(.display, "flex")
            .style(self.isImage ? .init(.flexDirection, value: "column") : nil)
            .style(.overflow, "hidden")
            .style(edgeAlignmentRules)
            .style(alignment.flexAlignmentRules)
            .style(.width, "100%")
            .style(.height, "100%")
    }
}
