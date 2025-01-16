//
// CornerRadius.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies corner radius styling to HTML elements
struct CornerRadiusModifier: HTMLModifier {
    /// The edges to apply corner radius to
    private let edges: DiagonalEdge

    /// The radius value to apply
    private let length: LengthUnit

    /// Creates a new corner radius modifier with a string length
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: The radius value.
    init(edges: DiagonalEdge, length: LengthUnit) {
        self.edges = edges
        self.length = length
    }

    /// Creates a new corner radius modifier with a pixel length
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - pixels: The radius value in pixels
    init(edges: DiagonalEdge, pixels: Int) {
        self.edges = edges
        self.length = .px(pixels)
    }

    /// Applies corner radius styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with corner radius applied
    func body(content: some HTML) -> any HTML {
        styleCornerRadius(
            content: content,
            edges: edges,
            length: length)
    }
}

public extension HTML {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: LengthUnit) -> some HTML {
        cornerRadius(.all, length)
    }

    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to round corners with.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: Int) -> some HTML {
        cornerRadius(.all, length)
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: LengthUnit) -> some HTML {
        modifier(CornerRadiusModifier(edges: edges, length: length))
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: An integer specifying a pixel amount to round corners with
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> some HTML {
        modifier(CornerRadiusModifier(edges: edges, pixels: length))
    }
}

public extension StyledHTML {
    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: A string with rounding of your choosing.
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge = .all, _ length: LengthUnit) -> Self {
        styleCornerRadius(
            content: self,
            edges: edges,
            length: length)
    }
}

// A helper method that encapsulates the corner-radius generation logic.
@MainActor fileprivate func styleCornerRadius<T: Modifiable>(
    content: T,
    edges: DiagonalEdge = .all,
    length: LengthUnit
) -> T {
    if edges.contains(.all) {
        return content.style(.init(name: .borderRadius, value: length.stringValue))
    }

    if edges.contains(.topLeading) {
        content.style(.init(name: .borderTopLeftRadius, value: length.stringValue))
    }

    if edges.contains(.topTrailing) {
        content.style(.init(name: .borderTopRightRadius, value: length.stringValue))
    }

    if edges.contains(.bottomLeading) {
        content.style(.init(name: .borderBottomLeftRadius, value: length.stringValue))
    }

    if edges.contains(.bottomTrailing) {
        content.style(.init(name: .borderBottomRightRadius, value: length.stringValue))
    }

    return content
}
