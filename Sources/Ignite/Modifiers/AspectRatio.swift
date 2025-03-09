//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specific aspect ratios that are commonly used
public enum AspectRatio: String, CaseIterable, Sendable {
    /// A square aspect ratio.
    case square = "1x1"

    /// A 4:3 aspect ratio.
    case r4x3 = "4x3"

    /// A 16:9 aspect ratio.
    case r16x9 = "16x9"

    /// A 21:9 aspect ratio.
    case r21x9 = "21x9"
}

/// The content mode of an element, e.g. an image, within its container.
public enum ContentMode: CaseIterable, Sendable {
    /// The element is sized to fit into the container.
    case fit

    /// The element is sized to fill the container, possibly cutting of parts of the element.
    case fill

    var htmlClass: String {
        "object-fit-\(self == .fill ? "cover" : "contain")"
    }
}

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
