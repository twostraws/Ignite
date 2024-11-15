//
// AnimationManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A thread-safe manager class that handles registration and generation of CSS animations.
///
/// `AnimationManager` serves as the central coordinator for all animations in an Ignite application,
/// managing their registration, storage, and CSS generation. It ensures thread safety through
/// the `@MainActor` attribute.
@MainActor
final class AnimationManager {
    /// The shared singleton instance of the animation manager.
    static let shared = AnimationManager()
    
    /// Storage for registered animations, keyed by element ID and trigger type.
    ///
    /// The structure maps element IDs to a dictionary of animation triggers and their
    /// corresponding resolved animations.
    private var animations: [String: [AnimationTrigger: ResolvedAnimation]] = [:]
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Registers a resolved animation for a specific element.
    ///
    /// - Parameters:
    ///   - animation: The resolved animation to register
    ///   - elementID: The unique identifier of the element to animate
    func registerAnimation(_ animation: ResolvedAnimation, for elementID: String) {
        // If animations already exist for this element
        if let existingAnimations = animations[elementID] {
            // Only register if we don't already have this type of animation
            if !existingAnimations.values.contains(where: { $0.trigger == animation.trigger }) {
                // Use existing name for consistency if there are other animations
                var resolvedAnimation = animation
                resolvedAnimation.name = existingAnimations.values.first?.name ?? animation.name
                animations[elementID, default: [:]][animation.trigger] = resolvedAnimation
            }
        } else {
            // No existing animations, register normally
            animations[elementID, default: [:]][animation.trigger] = animation
        }
    }
    
    /// Registers any animation type for a specific element.
    ///
    /// This method attempts to resolve the animation into a `ResolvedAnimation` through
    /// various means before registration.
    ///
    /// - Parameters:
    ///   - animation: The animation to register
    ///   - elementID: The unique identifier of the element to animate
    func registerAnimation(_ animation: some Animation, for elementID: String) {
        if let resolved = animation as? ResolvedAnimation {
            registerAnimation(resolved, for: elementID)
            return
        }
        
        if let resolved = AnimationBuilder.buildBlock(animation) as? ResolvedAnimation {
            registerAnimation(resolved, for: elementID)
            return
        }
        
        if let resolved = AnimationBuilder.buildBlock(animation.body) as? ResolvedAnimation {
            registerAnimation(resolved, for: elementID)
            return
        }
    }
    
    /// Generates and writes CSS for all registered animations to a file.
    ///
    /// This method creates CSS blocks for each registered animation and combines them
    /// into a single CSS file.
    ///
    /// - Parameter file: The URL where the CSS file should be written
    func write(to file: URL) {
        // Group animations by name to deduplicate
        var uniqueAnimations: [String: [AnimationTrigger: ResolvedAnimation]] = [:]
        
        for elementAnimations in animations.values {
            for (trigger, animation) in elementAnimations {
                if uniqueAnimations[animation.name] == nil {
                    uniqueAnimations[animation.name] = [:]
                }
                uniqueAnimations[animation.name]?[trigger] = animation
            }
        }
        
        // Generate CSS only for unique animations
        let cssBlocks = uniqueAnimations.map { name, triggerMap in
            let builder = AnimationClassGenerator(name: name, triggerMap: triggerMap)
            return builder.build()
        }
        
        let css = cssBlocks.joined(separator: "\n\n")
        try? css.write(to: file, atomically: true, encoding: .utf8)
    }
    
    /// Retrieves all registered animations for a specific element.
    ///
    /// - Parameter elementID: The unique identifier of the element
    /// - Returns: A dictionary mapping triggers to their corresponding animations, or nil if none exist
    func getAnimations(for elementID: String) -> [AnimationTrigger: ResolvedAnimation]? {
        return animations[elementID]
    }
}
