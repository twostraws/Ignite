//
// ImageFit-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension Image {
    /// Applies sizing and positioning behavior to an image.
    /// - Parameters:
    ///   - fit: The scaling behavior to apply to the image. Defaults to `.cover`
    ///   - anchor: The position within the container where the image should be anchored. Defaults to `.center`
    /// - Returns: A modified image with the specified fit and anchor point applied
    func imageFit(
        _ fit: ImageFit = .cover,
        anchor: UnitPoint = .center
    ) -> Self {
        let xPercent = Int(anchor.x * 100)
        let yPercent = Int(anchor.y * 100)

        return self
            .class("w-100 h-100 object-fit-\(fit.rawValue)")
            .style("object-position: \(xPercent)% \(yPercent)%")
    }
}
