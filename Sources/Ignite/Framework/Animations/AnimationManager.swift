//
// AnimationManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The AnimationManager is responsible for:
/// - Registering animations for HTML elements
/// - Generating CSS keyframes and animation classes
/// - Managing multiple animations per element
/// - Writing compiled CSS to the build directory
@MainActor
final class AnimationManager {
    /// Shared instance of the AnimationManager
    static let shared = AnimationManager()
    
    /// Storage for animations, keyed by element ID and trigger type
    /// - Key: Element ID string
    /// - Value: Dictionary mapping triggers to animation data
    private var animations: [String: [AnimationTrigger: AnimationData]] = [:]
    
    private init() {}
    
    /// Registers an animation for a specific element and trigger
    /// - Parameters:
    ///   - animation: The animation configuration to register
    ///   - elementId: Unique identifier for the HTML element
    ///   - trigger: The event that triggers the animation
    /// - Note: If an animation already exists for the element and trigger, properties will be merged
    func registerAnimation(_ animation: Animation, for elementID: String, trigger: AnimationTrigger) {
        if animations[elementID] == nil {
            animations[elementID] = [:]
        }
        
        if let existing = animations[elementID]?[trigger] {
            let combinedProps = Array(Set(existing.animation.properties + animation.properties))
            let mergedAnimation = Animation(
                duration: animation.duration,
                cssTimingFunction: animation.cssTimingFunction,
                delay: animation.delay,
                repeatCount: animation.repeatCount,
                autoreverses: animation.autoreverses,
                properties: combinedProps
            )
            animations[elementID]?[trigger] = AnimationData(
                elementID: elementID,
                animation: mergedAnimation,
                trigger: trigger
            )
        } else {
            animations[elementID]?[trigger] = AnimationData(
                elementID: elementID,
                animation: animation,
                trigger: trigger
            )
        }
    }
    
    /// Generates keyframe animations for a specific animation configuration
    /// - Parameters:
    ///   - name: Base name for the keyframe animation
    ///   - animation: Animation configuration
    ///   - trigger: The trigger type determining keyframe structure
    /// - Returns: CSS keyframe definitions as a string
    private func generateKeyframes(name: String, animation: Animation, trigger: AnimationTrigger) -> String {
        let propertyString = { (useInitial: Bool) in
            animation.properties.map { "\($0.name): \(useInitial ? $0.initial : $0.final)" }
                .joined(separator: "; ")
        }
        
        return switch trigger {
        case .hover:
            """
            @keyframes \(name)-hover {
                from { \(propertyString(true)) }
                to { \(propertyString(false)) }
            }
            
            @keyframes \(name)-unhover {
                from { \(propertyString(false)) }
                to { \(propertyString(true)) }
            }
            """
        case .click:
            """
            @keyframes \(name)-click {
                from { \(propertyString(true)) }
                to { \(propertyString(false)) }
            }
            
            @keyframes \(name)-unclick {
                from { \(propertyString(false)) }
                to { \(propertyString(true)) }
            }
            """
        case .appear:
            """
            @keyframes \(name)-appear {
                from { \(propertyString(true)) }
                to { \(propertyString(false)) }
            }
            """
        }
    }
    
    /// Generates CSS classes for animations
    /// - Parameters:
    ///   - name: Base class name for the animation
    ///   - animations: Dictionary of animations by trigger
    /// - Returns: CSS class definitions as a string
    private func generateAnimationClass(name: String, animations: [AnimationTrigger: AnimationData]) -> String {
        animations.map { trigger, definition in
            let suffix = trigger == .appear ? "appear" : trigger.rawValue
            
            return switch trigger {
            case .hover:
                """
                .\(name):hover {
                    animation: \(name)-hover \(definition.animation.duration)s \(definition.animation.cssTimingFunction) forwards;
                }
                .\(name):not(:hover) {
                    animation: \(name)-unhover \(definition.animation.duration)s \(definition.animation.cssTimingFunction) forwards;
                }
                """
            case .click:
                """
                .\(name).clicked {
                    animation: \(name)-\(suffix) \(definition.animation.duration)s \(definition.animation.cssTimingFunction) forwards;
                }
                .\(name).clicked.reverse {
                    animation: \(name)-un\(suffix) \(definition.animation.duration)s \(definition.animation.cssTimingFunction) forwards;
                }
                """
            case .appear:
                """
                .\(name) {
                    animation: \(name)-\(suffix) \(definition.animation.duration)s \(definition.animation.cssTimingFunction) forwards;
                }
                """
            }
        }.joined(separator: "\n")
    }
    
    /// Generates complete CSS for an element's animations
    /// - Parameters:
    ///   - elementId: The element's unique identifier
    ///   - animations: Dictionary of animations by trigger
    /// - Returns: Combined keyframes and classes as a string
    private func generateAnimationCSS(_ elementId: String, animations: [AnimationTrigger: AnimationData]) -> String {
        let name = "animation-\(elementId)"
        
        let keyframes = animations.map { trigger, definition in
            generateKeyframes(name: name, animation: definition.animation, trigger: trigger)
        }.joined(separator: "\n\n")
        
        let animationClass = generateAnimationClass(name: name, animations: animations)
        
        return keyframes + "\n\n" + animationClass
    }
    
    /// Generates complete CSS for all registered animations
    /// - Returns: Complete CSS string for all animations
    func generateCSS() -> String {
        animations.map { elementId, triggerMap in
            generateAnimationCSS(elementId, animations: triggerMap)
        }.joined(separator: "\n\n")
    }
    
    /// Writes generated CSS to the build directory and clears registered animations
    /// - Parameter context: The publishing context containing build directory information
    func write(to file: URL) {
        let css = generateCSS()
        try? css.write(to: file, atomically: true, encoding: .utf8)
        animations.removeAll()
    }
}
