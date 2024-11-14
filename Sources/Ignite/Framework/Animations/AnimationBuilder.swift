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
        guard let component = components.first else { return ResolvedAnimation() }
        
        if let resolved = component as? ResolvedAnimation {
            return resolved
        }
        
        if let resolved = component.body as? ResolvedAnimation {
            var copy = resolved
            copy.name = component.name
            return copy
        }
        
        if let standard = component.body as? StandardAnimation ?? component as? StandardAnimation {
            return ResolvedAnimation(
                name: component.name,
                frames: [Frame("100%", animation: standard)],
                trigger: standard.trigger,
                duration: standard.duration,
                timing: standard.timing,
                delay: standard.delay,
                repeatCount: standard.repeatCount,
                autoreverses: standard.autoreverses
            )
        }
        
        if let keyframes = component.body as? KeyframeAnimation ?? component as? KeyframeAnimation {
            return ResolvedAnimation(
                name: component.name,
                frames: keyframes.frames,
                trigger: keyframes.trigger,
                duration: keyframes.duration,
                timing: keyframes.timing,
                delay: keyframes.delay,
                repeatCount: keyframes.repeatCount,
                autoreverses: keyframes.autoreverses
            )
        }
        
        return buildBlock(component.body)
    }
    
    /// Combines multiple Frame components into a single array for keyframe animations
    public static func buildBlock(_ components: Frame...) -> [Frame] {
        components
    }
    
    /// Passes through a single Frame component without modification
    public static func buildExpression(_ frame: Frame) -> Frame {
        frame
    }
    
    /// Passes through a single StandardAnimation component without modification
    public static func buildExpression(_ expression: StandardAnimation) -> StandardAnimation {
        expression
    }
    
    /// Takes multiple StandardAnimations and returns the first one, used for frame closures
    public static func buildBlock(_ components: StandardAnimation...) -> StandardAnimation {
        components[0]
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
}
