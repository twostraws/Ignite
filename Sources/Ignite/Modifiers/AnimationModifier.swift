//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
        return AnimatedHTML(self, animation: animation, trigger: trigger)
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
        return AnimatedHTML(self, animation: animation, trigger: trigger)
    }
}
