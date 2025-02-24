//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies animations or transitions to HTML elements.
struct AnimationModifier: HTMLModifier {
    /// The animation to apply.
    var animation: Animation

    /// The event that triggers this animation (.hover, .click, or .appear).
    var trigger: AnimationTrigger

    /// Applies the animation or transition to the provided HTML content.
    /// - Parameter content: The HTML content to animate
    /// - Returns: The modified HTML content with animation attributes applied
    func body(content: some HTML) -> any HTML {
        AnimatedHTML(content, animation: animation, trigger: trigger)
    }
}

public extension HTML {
    /// Applies a keyframe animation to an HTML element.
    /// - Parameters:
    ///   - trigger: The event that triggers this animation
    ///   - options: Settings like speed, duration, and fill mode
    ///   - content: A closure that builds the keyframes
    /// - Returns: A modified HTML element with the animation applied.
    func animation(
        _ trigger: AnimationTrigger,
        options: [AnimationOption] = [],
        @KeyframeBuilder _ content: (KeyframeProxy) -> [Keyframe]
    ) -> some HTML {
        var animation = Animation(frames: content(KeyframeProxy()))
        animation.with(options)
        return modifier(AnimationModifier(animation: animation, trigger: trigger))
    }

    /// Applies a predefined animation to an HTML element.
    /// - Parameters:
    ///   - animation: The animation to apply
    ///   - trigger: The event that triggers this animation
    ///   - options: Settings like speed, duration, and fill mode
    /// - Returns: A modified HTML element with the animation applied.
    func animation(
        _ animation: Animation,
        on trigger: AnimationTrigger,
        options: [AnimationOption] = []
    ) -> some HTML {
        var animation = animation
        animation.with(options)
        return modifier(AnimationModifier(animation: animation, trigger: trigger))
    }
}
