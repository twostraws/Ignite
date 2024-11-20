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
    static let `default` = AnimationManager()
    
    /// Storage for registered animations, keyed by element ID and trigger type.
    ///
    /// The structure maps element IDs to a dictionary of animation triggers and their
    /// corresponding resolved animations.
    private var animations: [String: [AnimationTrigger: any Animation]] = [:]
    
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
    func register(_ animation: some Animation, for elementID: String) {
        if animations[elementID] == nil {
            animations[elementID] = [:]
        }
        animations[elementID]?[animation.trigger] = animation
    }
    
    /// Retrieves a specific animation for an element and trigger type.
    ///
    /// - Parameters:
    ///   - elementID: The unique identifier of the element
    ///   - trigger: The animation trigger type to retrieve
    /// - Returns: The animation for the specified trigger, or nil if none exists
    func getAnimation(for elementID: String, trigger: AnimationTrigger) -> (any Animation)? {
        return animations[elementID]?[trigger]
    }
    
    func getAnimations(for elementID: String) -> [any Animation] {
        return animations[elementID]?.values.map { $0 } ?? []
    }
    
    /// Generates and writes CSS for all registered animations to a file.
    ///
    /// This method creates CSS blocks for each registered animation and combines them
    /// into a single CSS file.
    ///
    /// - Parameter file: The URL where the CSS file should be written
    func write(to file: URL) {
        let cssBlocks = animations.map { elementID, triggerMap in
            let name = "animation-" + elementID
            let generator = AnimationClassGenerator(name: name, triggerMap: triggerMap)
            return generator.build()
        }
        
        let css = cssBlocks.joined(separator: "\n\n")
        try? css.write(to: file, atomically: true, encoding: .utf8)
    }
}
