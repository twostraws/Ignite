//
// TransitionModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies animations or transitions to HTML elements.
struct TransitionModifier: HTMLModifier {
    /// The transition to apply.
    var transition: Transition

    /// The event that triggers this animation (.hover, .click, or .appear).
    var trigger: AnimationTrigger

    /// Applies the animation or transition to the provided HTML content.
    /// - Parameter content: The HTML content to animate
    /// - Returns: The modified HTML content with animation attributes applied
    func body(content: some HTML) -> any HTML {
        AnimatedHTML(content, animation: transition, trigger: trigger)
    }
}

public extension HTML {
    /// Applies a transition animation to an HTML element.
    ///
    /// - Parameters:
    ///   - transition: The transition animation to apply.
    ///   - trigger: The event that triggers this animation (.hover, .click, or .appear).
    /// - Returns: A modified HTML element with the animation applied.
    func transition(_ transition: Transition, on trigger: AnimationTrigger) -> some HTML {
        modifier(TransitionModifier(transition: transition, trigger: trigger))
    }
}
