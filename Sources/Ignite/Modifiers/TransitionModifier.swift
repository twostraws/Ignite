//
// TransitionModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a transition animation to an HTML element.
    ///
    /// - Parameters:
    ///   - transition: The transition animation to apply.
    ///   - trigger: The event that triggers this animation (.hover, .click, or .appear).
    /// - Returns: A modified HTML element with the animation applied.
    func transition(_ transition: Transition, on trigger: AnimationTrigger) -> some HTML {
        AnimatedHTML(self, animation: transition, trigger: trigger)
    }
}
