//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Specific aspect ratios that are commonly used
public enum AspectRatio: String {
    /// A square aspect ratio.
    case square = "1x1"

    /// A 4:3 aspect ratio.
    case r4x3 = "4x3"

    /// A 16:9 aspect ratio.
    case r16x9 = "16x9"

    /// A 21:9 aspect ratio.
    case r21x9 = "21x9"
}

extension BlockElement {
    /// Applies a fixed aspect ratio to the current element.
    /// - Parameter ratio: The aspect ratio to apply.
    /// - Returns: A new instance of this element with the ratio applied.
    public func aspectRatio(_ ratio: AspectRatio) -> Self {
        self.class("ratio", "ratio-\(ratio.rawValue)")
    }

    /// Applies a custom ratio to the current element.
    /// - Parameter aspectRatio: The ratio to use, relative to 1.
    /// For example, specifying 2 here will make a 2:1 aspect ratio.
    /// - Returns: A new instance of this element with the ratio applied.
    public func aspectRatio(_ aspectRatio: Double) -> Self {
        let percentage = 100 / aspectRatio
        return self
            .class("ratio")
            .style("--bs-aspect-ratio: \(percentage)%")
    }
}
