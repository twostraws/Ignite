//
// BackgroundImageModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies background image styling to HTML elements.
private struct BackgroundImageModifier: HTMLModifier {
    /// The path to the background image.
    var image: String
    /// How the background image should be sized within its container.
    var contentMode: BackgroundImageContentMode
    /// Whether the background image should repeat.
    var repeats: Bool
    /// The position of the background image within its container.
    var position: BackgroundPosition

    func body(content: Content) -> some HTML {
        content
            .style(
                .init(.backgroundImage, value: "url('\(image)')"),
                .init(.backgroundSize, value: contentMode.css),
                .init(.backgroundRepeat, value: repeats ? "repeat" : "no-repeat"),
                .init(.backgroundPosition, value: position.css)
            )
    }
}

public extension HTML {
    /// Applies a background image to the element.
    /// - Parameters:
    ///   - image: The path to the image
    ///   - contentMode: How the image should be sized
    ///   - position: The position of the image within the element
    ///   - repeats: Whether the image should be repeated
    /// - Returns: A modified element with the background image applied
    func background(
        image: String,
        contentMode: BackgroundImageContentMode,
        position: BackgroundPosition = .center,
        repeats: Bool = false
    ) -> some HTML {
        modifier(BackgroundImageModifier(
            image: image,
            contentMode: contentMode,
            repeats: repeats,
            position: position))
    }
}
