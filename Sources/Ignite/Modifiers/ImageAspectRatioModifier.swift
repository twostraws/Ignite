//
// ImageAspectRatioModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies aspect ratio and content mode styling to image elements.
private struct ImageAspectRatioModifier: HTMLModifier {
    /// The aspect ratio to apply to the image.
    var ratio: AspectRatioAmount
    /// The content mode that determines how the image fills its container.
    var contentMode: ContentMode

    func body(content: Content) -> some HTML {
        let content = Section(content.class(contentMode.htmlClass))
        ModifiedHTML(content: content, modifier: AspectRatioModifer(ratio: ratio))
    }
}

public extension Image {
    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The aspect ratio to apply.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: AspectRatio, contentMode: ContentMode) -> some HTML {
        ModifiedHTML(
            content: InlineHTML(self),
            modifier: ImageAspectRatioModifier(ratio: .semantic(ratio), contentMode: contentMode))
    }

    /// Applies a fixed aspect ratio to the image element.
    /// - Parameters:
    ///   - ratio: The ratio to use, relative to 1.
    ///   - contentMode: The content mode to apply.
    /// - Returns: A new instance of this element with the ratio and content mode applied.
    func aspectRatio(_ ratio: Double, contentMode: ContentMode) -> some HTML {
        ModifiedHTML(
            content: InlineHTML(self),
            modifier: ImageAspectRatioModifier(ratio: .exact(ratio), contentMode: contentMode))
    }
}
