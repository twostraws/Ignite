//
// CornerRadius.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies corner radius styling to HTML elements
struct CornerRadiusModifier: HTMLModifier {
    /// The edges to apply corner radius to
    private let edges: DiagonalEdge

    /// The radius value to apply
    private let length: String

    /// Creates a new corner radius modifier with a string length
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - length: The radius value as a string (e.g. "50%", "10px")
    init(edges: DiagonalEdge, length: String) {
        self.edges = edges
        self.length = length
    }

    /// Creates a new corner radius modifier with a pixel length
    /// - Parameters:
    ///   - edges: Which corners should be rounded
    ///   - pixels: The radius value in pixels
    init(edges: DiagonalEdge, pixels: Int) {
        self.edges = edges
        self.length = "\(pixels)px"
    }

    /// Applies corner radius styling to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with corner radius applied
    func body(content: some HTML) -> any HTML {
        if edges.contains(.all) {
            return content.style("border-radius: \(length)")
        }

        var modified = content

        if edges.contains(.topLeading) {
            modified = modified.style("border-top-left-radius: \(length)")
        }

        if edges.contains(.topTrailing) {
            modified = modified.style("border-top-right-radius: \(length)")
        }

        if edges.contains(.bottomLeading) {
            modified = modified.style("border-bottom-left-radius: \(length)")
        }

        if edges.contains(.bottomTrailing) {
            modified = modified.style("border-bottom-right-radius: \(length)")
        }

        return modified
    }
}

public extension HTML {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as "50%".
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ length: String) -> some HTML {
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
    ///   - length: A string with rounding of your choosing, such as "50%"
    /// - Returns: A modified copy of the element with corner radius applied
    func cornerRadius(_ edges: DiagonalEdge, _ length: String) -> some HTML {
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
