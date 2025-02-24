//
// AnimationFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public typealias Keyframe = Animation.Frame

public extension Animation {
    /// A single keyframe in an animation sequence.
    struct Frame: Hashable, Sendable {
        /// The position in the animation timeline, between `0%` and `100%`
        let position: Percentage

        /// The property transformations to apply at this position
        var styles: OrderedSet<InlineStyle>

        /// Creates a frame with a single predefined animation
        init(_ position: Percentage, data: OrderedSet<InlineStyle> = []) {
            precondition(
                position >= 0% && position <= 100%,
                "Animation frame position must be between 0% and 100%, got \(position)%"
            )
            self.position = position
            self.styles = data
        }
    }
}

public extension Keyframe {
    /// Sets a color for this keyframe
    /// - Parameters:
    ///   - area: Which color property to animate (text or background). Default is `.foreground`.
    ///   - value: The color to animate to
    /// - Returns: A new keyframe with the color animation applied
    func color(_ area: ColorArea = .foreground, to value: Color) -> Keyframe {
        var copy = self
        copy.styles.append(.init(animatable: area.property, value: value.description))
        return copy
    }

    /// Sets the scale transform for this keyframe
    /// - Parameter value: The scale factor to animate to (e.g., 1.5 for 150% size)
    /// - Returns: A new keyframe with the scale transform applied
    func scale(_ value: Double) -> Keyframe {
        var copy = self
        copy.styles.append(.init(animatable: .transform, value: "scale(\(value))"))
        return copy
    }

    /// Sets the rotation transform for this keyframe
    /// - Parameters:
    ///   - angle: The angle to rotate by
    ///   - anchor: The point around which to rotate (defaults to center)
    /// - Returns: A new keyframe with the rotation transform applied
    func rotate(_ angle: Angle, anchor: AnchorPoint = .center) -> Keyframe {
        var copy = self
        copy.styles.append(.init(.transformOrigin, value: anchor.value))
        copy.styles.append(.init(.transform, value: "rotate(\(angle.value))"))
        return copy
    }

    /// Sets a custom style transformation for this keyframe
    /// - Parameters:
    ///   - property: The CSS property to animate
    ///   - value: The CSS value
    /// - Returns: A new keyframe with the custom animation applied
    func custom(_ property: AnimatableProperty, value: String) -> Keyframe {
        var copy = self
        copy.styles.append(.init(animatable: property, value: value))
        return copy
    }
}
