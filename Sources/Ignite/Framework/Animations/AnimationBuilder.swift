//
// AnimationBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables a declarative syntax for creating complex animations.
///
/// `AnimationBuilder` provides the foundation for Ignite's animation DSL, allowing animations
/// to be composed from simple building blocks into more complex sequences. It handles the conversion
/// of various animation types into `ResolvedAnimation` instances that can be rendered to CSS.
@resultBuilder
public struct AnimationBuilder {
    /// Builds a single animation from one or more animation components.
    /// Converts various animation types into a resolved animation for rendering.
    public static func buildBlock(_ components: any Animation...) -> some Animation {
        // If no components provided, return empty ResolvedAnimation
        guard let component = components.first else { return ResolvedAnimation() }
        
        // Case 1: Component is already a ResolvedAnimation
        // Return it directly since no further processing needed
        if let resolved = component as? ResolvedAnimation {
            return resolved
        }
        
        // Case 2: Component's body is a ResolvedAnimation
        // Copy it and update the name to maintain component identity
        if let resolved = component.body as? ResolvedAnimation {
            var copy = resolved
            copy.name = component.name
            return copy
        }
        
        // Case 3: Component is or contains a BasicAnimation
        // Convert it to a ResolvedAnimation with start/end frames
        if let standard = component.body as? BasicAnimation ?? component as? BasicAnimation {
            return ResolvedAnimation(
                name: component.name,
                frames: [
                    AnimationFrame(0%, animations: [standard]),
                    AnimationFrame(100%, animations: [standard])
                ],
                trigger: standard.trigger,
                duration: standard.duration,
                timing: standard.timing,
                delay: standard.delay,
                repeatCount: standard.repeatCount,
                autoreverses: standard.autoreverses,
                staticProperties: standard.staticProperties,
                isKeyframe: false
            )
        }

        // Case 4: Component is or contains a KeyframeAnimation
        // Convert it to a ResolvedAnimation preserving all frames
        if let keyframes = component.body as? KeyframeAnimation ?? component as? KeyframeAnimation {
            return ResolvedAnimation(
                name: component.name,
                frames: keyframes.frames,
                trigger: keyframes.trigger,
                duration: keyframes.duration,
                timing: keyframes.timing,
                delay: keyframes.delay,
                repeatCount: keyframes.repeatCount,
                autoreverses: keyframes.autoreverses,
                isKeyframe: true
            )
        }
        
        // Case 5: None of the above matched
        // Recursively try to build from component's body
        return buildBlock(component.body)
    }
    
    /// Combines multiple Frame components into a single array for keyframe animations
    public static func buildBlock(_ components: AnimationFrame...) -> [AnimationFrame] {
        components
    }
    
    /// Passes through a single Frame component without modification
    public static func buildExpression(_ frame: AnimationFrame) -> AnimationFrame {
        frame
    }
    
    /// Passes through a single StandardAnimation component without modification
    public static func buildExpression(_ expression: BasicAnimation) -> BasicAnimation {
        expression
    }
    
    /// Handles the 'true' branch of conditional animations
    public static func buildEither<Content: Animation>(first component: Content) -> Content {
        component
    }
    
    /// Handles the 'false' branch of conditional animations
    public static func buildEither<Content: Animation>(second component: Content) -> Content {
        component
    }
    
    /// Provides a default animation when an optional animation is nil
    public static func buildOptional(_ component: (any Animation)?) -> any Animation {
        component ?? ResolvedAnimation()
    }
    
    /// Takes multiple StandardAnimations and returns them as an array
    public static func buildBlock(_ components: BasicAnimation...) -> [BasicAnimation] {
        components
    }
}
