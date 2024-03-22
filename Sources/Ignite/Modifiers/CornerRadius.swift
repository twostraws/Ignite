//
// CornerRadius.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Rounds all edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as
    /// "50%".
    /// - Returns: The current element with the updated corner radius applied.
    public func cornerRadius(_ length: String) -> Self {
        self.cornerRadius(.all, length)
    }

    /// Rounds all edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to
    /// round corners with.
    /// - Returns: The current element with the updated corner radius applied.
    public func cornerRadius(_ length: Int) -> Self {
        self.cornerRadius(.all, "\(length)px")
    }

    /// Rounds selected edges of this object by some value specified as a string.
    /// - Parameter length: A string with rounding of your choosing, such as
    /// "50%".
    /// - Returns: The current element with the updated corner radius applied.
    public func cornerRadius(_ edges: DiagonalEdge, _ length: String) -> Self {
        if edges.contains(.all) {
            return self.style("border-radius: \(length)")
        }

        var copy = self

        if edges.contains(.topLeading) {
            copy = copy.style("border-top-left-radius: \(length)")
        }

        if edges.contains(.topTrailing) {
            copy = copy.style("border-top-right-radius: \(length)")
        }

        if edges.contains(.bottomLeading) {
            copy = copy.style("border-bottom-left-radius: \(length)")
        }

        if edges.contains(.bottomTrailing) {
            copy = copy.style("border-bottom-right-radius: \(length)")
        }

        return copy
    }

    /// Rounds selected edges of this object by some number of pixels.
    /// - Parameter length: An integer specifying a pixel amount to
    /// round corners with.
    /// - Returns: The current element with the updated corner radius applied.
    public func cornerRadius(_ edges: DiagonalEdge, _ length: Int) -> Self {
        self.cornerRadius(edges, "\(length)px")
    }
}
