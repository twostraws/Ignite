//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Applies an animation to an HTML element with default settings.
    /// - Parameter animation: The animation to apply to the element.
    /// - Returns: A modified copy of the HTML element with the animation applied.
    func animation(_ animation: some Animation) -> Self {
        var copy = self
        
        if let resolved = animation as? ResolvedAnimation, resolved.trigger == .click {
            copy.attributes = attributes
            return copy.animation(animation, on: .click)
        }
        
        // Set appear as default trigger
        return copy.animation(animation, on: .appear)
    }
    
    /// Applies an animation to an HTML element with specific trigger and oscillation settings.
    /// - Parameters:
    ///   - animation: The animation to apply to the element.
    ///   - oscillate: Whether the animation should reverse when completed. Defaults to `true`.
    ///   - trigger: The event that starts the animation (`.click`, `.hover`, or `.appear`).
    /// - Returns: A modified copy of the HTML element with the animation applied.
    func animation(_ animation: some Animation, oscillate: Bool = true, on trigger: AnimationTrigger) -> Self {
        var copy = self
        
        // Only apply inline-block if it's a transform animation
        if animation is StandardAnimation && (animation as? StandardAnimation)?.property == "transform" {
            copy.style(.init(name: "display", value: "inline-block"))
        }
        
        // Create a resolved animation with the correct trigger
        var resolved: ResolvedAnimation
        if let r = animation as? ResolvedAnimation {
            resolved = r
            resolved.trigger = trigger
        } else if let r = AnimationBuilder.buildBlock(animation) as? ResolvedAnimation {
            resolved = r
            resolved.trigger = trigger
        } else {
            resolved = ResolvedAnimation()
        }
        
        resolved.autoreverses = oscillate
        
        // Register the animation
        AnimationManager.shared.registerAnimation(resolved, for: copy.id)
        
        // Get the potentially updated name after registration
        if let registeredAnimation = AnimationManager.shared.getAnimations(for: copy.id)?[trigger] {
            resolved.name = registeredAnimation.name
        }
        
        copy.class(resolved.name)
        
        // Add trigger-specific classes and data attributes
        switch trigger {
        case .click:
            let clickClasses = resolved.name + "-clicked"
            copy.data("click-classes", clickClasses)
        case .appear:
            let appearClasses = resolved.name + "-appear"
            copy.data("appear-classes", appearClasses)
        case .hover:
            break
        }
        
        return copy
    }
}
