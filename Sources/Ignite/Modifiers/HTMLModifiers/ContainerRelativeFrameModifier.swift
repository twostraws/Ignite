//
// ContainerRelativeFrameModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that creates a flex container for positioning content relative to its container.
private struct ContainerRelativeFrameModifier: HTMLModifier {
    /// The alignment of content within the container.
    var alignment: Alignment

    func body(content: Content) -> some HTML {
        ContainerRelativeContent(content, alignment: alignment)
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
