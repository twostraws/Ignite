//
// ContainerRelativeFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that creates a flex container with horizontal alignment
struct ContainerRelativeFrameModifier: HTMLModifier {

    /// The horizontal alignment to apply to the container
    var alignment: HorizontalAlignment

    /// Creates a flex container around the provided content with specified alignment
    /// - Parameter content: The HTML element to wrap in a flex container
    /// - Returns: A Group containing the content with flex display and alignment applied
    func body(content: some HTML) -> any HTML {
        content
            .addContainerStyle(
                .init(name: .display, value: "flex"),
                .init(name: .justifyContent, value: alignment.justifyContent)
            )
    }
}

public extension HTML {
    /// Creates a flex container that allows its child to be positioned relative to its container.
    /// - Parameter alignment: How to align the content horizontally within the container. Default is `.center`.
    /// - Returns: A modified copy of the element with container-relative positioning applied.
    func containerRelativeFrame(_ alignment: HorizontalAlignment = .center) -> some HTML {
        modifier(ContainerRelativeFrameModifier(alignment: alignment))
    }
}
