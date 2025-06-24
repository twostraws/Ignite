//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

typealias AspectRatioAmount = Amount<Double, AspectRatio>

/// A modifier that applies aspect ratio styling to HTML elements.
struct AspectRatioModifer: HTMLModifier {
    /// The aspect ratio to apply to the element.
    var ratio: AspectRatioAmount

    func body(content: Content) -> some HTML {
        var modified = content
        switch ratio {
        case .exact(let ratio):
            let percentage = 100 / ratio
            modified.attributes.append(classes: "ratio")
            modified.attributes.append(styles: .init("--bs-aspect-ratio", value: "\(percentage)%"))
        case .semantic(let ratio):
            modified.attributes.append(classes: "ratio", "ratio-\(ratio.rawValue)")
        default: break
        }
        return modified
    }
}

public extension HTML {
    /// Applies a fixed aspect ratio to the current element.
    /// - Parameter ratio: The aspect ratio to apply.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ ratio: AspectRatio) -> some HTML {
        modifier(AspectRatioModifer(ratio: .semantic(ratio)))
    }

    /// Applies a custom ratio to the current element.
    /// - Parameter aspectRatio: The ratio to use, relative to 1.
    /// - Returns: A modified element with the aspect ratio applied.
    func aspectRatio(_ aspectRatio: Double) -> some HTML {
        modifier(AspectRatioModifer(ratio: .exact(aspectRatio)))
    }
}
