//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a fixed aspect ratio to the current element.
    /// - Parameter ratio: The aspect ratio to apply.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ ratio: AspectRatio) -> some HTML {
        self.class("ratio", "ratio-\(ratio.rawValue)")
    }

    /// Applies a custom ratio to the current element.
    /// - Parameter aspectRatio: The ratio to use, relative to 1.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ aspectRatio: Double) -> some HTML {
        let percentage = 100 / aspectRatio
        return self
            .class("ratio")
            .style("--bs-aspect-ratio", "\(percentage)%")
    }
}

public extension Image {
    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The aspect ratio to apply.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: AspectRatio, contentMode: ContentMode) -> some HTML {
        Section {
            self.class(contentMode.htmlClass)
        }
        .aspectRatio(ratio)
    }

    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The ratio to use, relative to 1.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: Double, contentMode: ContentMode) -> some HTML {
        Section {
            self.class(contentMode.htmlClass)
        }
        .aspectRatio(ratio)
    }
}
