//
// AnimationData.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that encapsulates all the necessary data for a CSS animation instance.
/// This type connects an animation configuration with a specific `HTML` element and trigger event.
public struct AnimationData: Hashable {
    /// The unique identifier of the `HTML` element this animation is attached to
    /// Used for generating CSS class names and managing animation state
    let elementID: String

    /// The animation configuration containing timing, properties and behavior
    /// See Animation.swift for available configuration options
    let animation: Animation

    /// The event that triggers this animation (click, hover, or appear)
    /// Controls how the animation is activated in the browser
    let trigger: AnimationTrigger
}
