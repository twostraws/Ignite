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
        style(content: content)
    }

    func style<T: Modifiable>(content: T) -> T {
        if edges.contains(.all) {
            return content.style("border-radius: \(length.stringValue)")
        }

        var modified = content

        if edges.contains(.topLeading) {
            modified.style("border-top-left-radius: \(length.stringValue)")
        }

        if edges.contains(.topTrailing) {
            modified.style("border-top-right-radius: \(length.stringValue)")
        }

        if edges.contains(.bottomLeading) {
            modified.style("border-bottom-left-radius: \(length.stringValue)")
        }

        if edges.contains(.bottomTrailing) {
            modified.style("border-bottom-right-radius: \(length.stringValue)")
        }

        return modified
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
