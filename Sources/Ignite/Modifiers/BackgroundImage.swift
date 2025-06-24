//
// BackgroundImage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
        self.style(
            .init(.backgroundImage, value: "url('\(image)')"),
            .init(.backgroundSize, value: contentMode.css),
            .init(.backgroundRepeat, value: repeats ? "repeat" : "no-repeat"),
            .init(.backgroundPosition, value: position.css)
        )
    }
}



