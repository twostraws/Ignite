//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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

/// The content mode of an element, e.g. an image, within its container.
public enum ContentMode {
    /// The element is sized to fit into the container.
    case fit

    /// The element is sized to fill the container, possibly cutting of parts of the element.
    case fill

    var htmlClass: String {
        "object-fit-\(self == .fill ? "cover" : "contain")"
    }
}

/// A modifier that applies aspect ratio constraints to HTML elements.
struct AspectRatioModifier: HTMLModifier {
    /// The predefined aspect ratio to apply, if using a standard ratio.
    var ratio: AspectRatio?

    /// The custom aspect ratio to apply, if using a custom value.
    var customRatio: Double?

    /// The content mode to apply when used with images.
    var contentMode: ContentMode?

    /// Applies the aspect ratio to the provided HTML content.
    /// - Parameter content: The HTML content to modify
    /// - Returns: The modified HTML content with aspect ratio applied
    func body(content: some HTML) -> any HTML {
        if let contentMode {
            if let ratio {
                Section {
                    content.class(contentMode.htmlClass)
                }
                .class("ratio", "ratio-\(ratio.rawValue)")
            } else if let customRatio {
                let percentage = 100 / customRatio
                Section {
                    content.class(contentMode.htmlClass)
                }
                .class("ratio")
                .style("--bs-aspect-ratio", "\(percentage)%")
            }
        } else if let ratio {
            content
                .class("ratio")
                .class("ratio-\(ratio.rawValue)")
        } else if let customRatio {
            let percentage = 100 / customRatio
            content
                .class("ratio")
                .style("--bs-aspect-ratio", "\(percentage)%")
        }
        content
    }
}

public extension BlockHTML {
    /// Applies a fixed aspect ratio to the current element.
    /// - Parameter ratio: The aspect ratio to apply.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ ratio: AspectRatio) -> some BlockHTML {
        modifier(AspectRatioModifier(ratio: ratio))
    }

    /// Applies a custom ratio to the current element.
    /// - Parameter aspectRatio: The ratio to use, relative to 1.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ aspectRatio: Double) -> some BlockHTML {
        modifier(AspectRatioModifier(customRatio: aspectRatio))
    }
}

public extension Image {
    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The aspect ratio to apply.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: AspectRatio, contentMode: ContentMode) -> some BlockHTML {
        Section {
            self.class(contentMode.htmlClass)
        }
        .class("ratio", "ratio-\(ratio.rawValue)")
    }

    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The ratio to use, relative to 1.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: Double, contentMode: ContentMode) -> some BlockHTML {
        let percentage = 100 / ratio
        return Section {
            self.class(contentMode.htmlClass)
        }
        .class("ratio")
        .style("--bs-aspect-ratio", "\(percentage)%")
    }
}
