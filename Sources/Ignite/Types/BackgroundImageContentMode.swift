//
// BackgroundImageContentMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The possible background sizes
public enum BackgroundImageContentMode: CSSRepresentable, Sendable {
    /// This is the default value. The background image is displayed at its original size.
    case original

    /// Scales the background image to cover the entire container while maintaining its aspect ratio.
    case fill

    /// Scales the background image to fit within the container without
    case fit

    /// The exact width and height using length values (pixels, ems, percentages, auto etc.)
    case size(width: String, height: String)

    /// The CSS name of the size.
    var css: String {
        switch self {
        case .original: "auto"
        case .fill: "cover"
        case .fit: "contain"
        case .size(let width, let height): "\(width) \(height)"
        }
    }
}
