//
// AnimationManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import OrderedCollections

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
    private var animations: [String: OrderedDictionary<AnimationTrigger, any Animatable>] = [:]

    /// Returns true if any animations have been registered
    var hasAnimations: Bool {
        !animations.isEmpty
    }

    /// Private initializer to enforce singleton pattern.
    private init() {}

    /// Registers a resolved animation for a specific element.
    /// - Parameters:
    ///   - animation: The resolved animation to register
    ///   - elementID: The unique identifier of the element to animate
    func register(_ animation: some Animatable, for elementID: String) {
        if animations[elementID] == nil {
            animations[elementID] = [:]
        }
        animations[elementID]?[animation.trigger] = animation
    }

    /// Returns all animation triggers registered for a specific HTML element.
    /// - Parameter elementID: The unique identifier of the HTML element
    /// - Returns: An array of animation triggers in registration order, or an empty array if none exist
    func getAnimationTriggers(for elementID: String) -> [AnimationTrigger] {
        animations[elementID]?.keys.elements ?? []
    }

    /// Retrieves a specific animation for an element and trigger type.
    /// - Parameters:
    ///   - elementID: The unique identifier of the element
    ///   - trigger: The animation trigger type to retrieve
    /// - Returns: The animation for the specified trigger, or nil if none exists
    func getAnimation(for elementID: String, trigger: AnimationTrigger) -> (any Animatable)? {
        return animations[elementID]?[trigger]
    }

    /// Returns all animations registered for a specific HTML element.
    /// - Parameter elementID: The unique identifier of the HTML element
    /// - Returns: An array of animations associated with the element, or an empty array if none exist
    func getAnimations(for elementID: String) -> [any Animatable] {
        return animations[elementID]?.values.map { $0 } ?? []
    }

    /// Generates and writes CSS for all registered animations to a file.
    /// - Parameter file: The URL where the CSS file should be written
    func write(to file: URL) {
        let cssBlocks = animations.map { elementID, triggerMap in
            let generator = AnimationClassGenerator(elementID: elementID, triggerMap: triggerMap)
            return generator.build()
        }

        let css = cssBlocks.joined(separator: "\n\n")
        try? css.write(to: file, atomically: true, encoding: .utf8)
    }
}
