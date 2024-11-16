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
    
    /// Returns true if any animations have been registered
    var hasAnimations: Bool {
        !animations.isEmpty
    }
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// Registers a resolved animation for a specific element.
    ///
    /// - Parameters:
    ///   - animation: The resolved animation to register
    ///   - elementID: The unique identifier of the element to animate
    func registerAnimation(_ animation: ResolvedAnimation, for id: String) {
        if var existingAnimations = animations[id] {
            if let existing = existingAnimations[animation.trigger] {
                // Merge frames from the same trigger
                var merged = existing
                // Combine frames, ensuring we don't duplicate
                let newFrames = animation.frames.filter { frame in
                    !existing.frames.contains { $0.position == frame.position }
                }
                merged.frames += newFrames
                existingAnimations[animation.trigger] = merged
            } else {
                existingAnimations[animation.trigger] = animation
            }
            animations[id] = existingAnimations
        } else {
            animations[id] = [animation.trigger: animation]
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
        // Check 1: Is this already a ResolvedAnimation?
        // If so, register it directly and exit early
        if let resolved = animation as? ResolvedAnimation {
            registerAnimation(resolved, for: elementID)
            return
        }
            
        // Check 2: Can the animation be built into a ResolvedAnimation?
        // This handles BasicAnimation and KeyframeAnimation types
        if let resolved = AnimationBuilder.buildBlock(animation) as? ResolvedAnimation {
            registerAnimation(resolved, for: elementID)
            return
        }
            
        // Check 3: Can the animation's body be built into a ResolvedAnimation?
        // This handles custom Animation types that implement the body property
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
