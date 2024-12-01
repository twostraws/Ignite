//
// ImageFit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents CSS object-fit values for images
public enum ImageFit: String {
    /// Stretches the image to fill the container without maintaining aspect ratio
    case fill = "fill"

    /// Scales the image to fit within the container while maintaining aspect ratio
    case fit = "contain"

    /// Scales the image to cover the container while maintaining aspect ratio, potentially cropping the image
    case cover = "cover"

    /// Similar to `fit` but never scales the image larger than its original size
    case scaleDown = "scale"

    /// Displays the image at its original size without scaling
    case none = "none"
}
