//
// AnimationClassGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A utility type that generates CSS classes for different types of animations.
///
/// `AnimationClassBuilder` converts Ignite animations into CSS classes, handling different
/// trigger types (hover, click, appear) and generating appropriate keyframes and transition rules.
struct AnimationClassGenerator {
    /// The base name for the generated CSS classes
    let name: String
    
    /// A mapping of trigger types to their corresponding resolved animations
    let triggerMap: [AnimationTrigger: ResolvedAnimation]
    
    /// Generates a CSS timing string for an animation, combining duration and timing function.
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function" where X is the duration in seconds
    private func getAnimationTiming(_ animation: ResolvedAnimation) -> String {
        "\(animation.duration)s \(animation.timing.cssValue)"
    }
    
    /// Generates the repeat count string for CSS animation properties
    /// - Parameter animation: The animation to generate the repeat count for
    /// - Returns: A string representing the CSS animation iteration count
    private func getRepeatCount(_ animation: ResolvedAnimation) -> String {
        if let count = animation.repeatCount {
            return count == .infinity ? " infinite" : " \(count)"
        }
        return ""
    }

    /// Determines if and what fill mode should be applied to the animation
    /// - Parameter animation: The animation to check for fill mode requirements
    /// - Returns: A string containing the CSS animation-fill-mode property if needed
    private func getFillMode(_ animation: ResolvedAnimation) -> String {
        let fillMode = animation.frames.first?.animations
            .compactMap { $0.property.fillMode.rawValue }
            .first
        
        return fillMode.map { " \($0)" } ?? ""
    }

    /// Generates CSS classes for appear animations
    /// - Parameter animation: The animation to generate appear classes for
    /// - Returns: A string containing the CSS class definition
    private func buildAppearClass(_ animation: ResolvedAnimation) -> String {
        let animationTiming = getAnimationTiming(animation)
        let repeatCount = getRepeatCount(animation)
        let fillMode = getFillMode(animation)
        
        // Final state properties
        let finalProperties = animation.frames.last?.animations.map { anim in
            "\(anim.property.rawValue): \(anim.to)"
        }.joined(separator: ";\n    ") ?? ""
        
        return """
        .\(name)-appear-final {
            \(finalProperties);
        }
        
        .\(name)-appear {
            animation: \(name)-appear \(animationTiming)\(repeatCount)\(fillMode);
        }
        """
    }
    
    /// Generates the base CSS class containing common properties
    /// - Returns: A string containing the base CSS class definition
    func buildBaseClass() -> String {
        var properties = Set<String>()
        
        if triggerMap[.click] != nil || triggerMap[.hover] != nil {
            properties.insert("cursor: pointer")
        }
        
        // Check if we have a color click animation
        let hasColorClick = triggerMap[.click]?.frames.first?.animations.contains { anim in
            anim.property.isColorProperty
        } ?? false
        
        // Add transition properties for hover animations
        if let hoverAnimation = triggerMap[.hover] {
            let hasTransform = hoverAnimation.frames.flatMap { frame in
                frame.animations.map { $0.property }
            }.contains { $0 == .transform }
            
            let hasColor = hoverAnimation.frames.flatMap { frame in
                frame.animations.map { $0.property }
            }.contains { $0.isColorProperty }
            
            let animationTiming = getAnimationTiming(hoverAnimation)
            
            // Combine all transition properties
            if hasTransform || hasColor {
                let transitionProps = [
                    hasTransform ? "transform" : nil,
                    // Only add color transition if we don't have a color click
                    (!hasColorClick && hasColor) ? "color" : nil
                ].compactMap { $0 }
                
                if !transitionProps.isEmpty {
                    properties.insert("transition: \(transitionProps.joined(separator: ", ")) \(animationTiming)")
                }
            }
        }
        
        // Handle initial states for click animations
        if let clickAnimation = triggerMap[.click] {
            clickAnimation.frames.first?.animations.forEach { anim in
                if anim.property.isColorProperty {
                    properties.insert("\(anim.property.rawValue): \(anim.from)")
                }
            }
        }
        
        // Only return the class if we have properties to include
        if properties.isEmpty {
            return ""
        }
        
        // Add any static styles from the animation
        if let clickAnimation = triggerMap[.click] {
            for style in clickAnimation.staticProperties {
                properties.insert("\(style.name): \(style.value)")
            }
        }
        
        return """
        .\(name) {
            \(properties.sorted().joined(separator: ";\n    "))
        }
        """
    }
    
    /// Generates CSS keyframe definitions for an animation
    private func buildKeyframes(_ animation: ResolvedAnimation) -> String {
        animation.generateKeyframes()
    }
    
    /// Generates CSS classes for click animations
    /// - Parameter animation: The animation to generate click classes for
    /// - Returns: A string containing the CSS class definitions
    private func buildClickClass(_ animation: ResolvedAnimation) -> String {
        let animationTiming = getAnimationTiming(animation)
        
        let hasColorAnimation = animation.frames.first?.animations.contains { anim in
            anim.property.isColorProperty
        } ?? false
        
        if hasColorAnimation {
            return buildColorClickClass(animation, timing: animationTiming)
        }
        
        // For keyframe animations
        if animation.frames.count > 1 {
            let keyframeName = "\(animation.name)-\(animation.trigger.rawValue)"
            return """
            .\(name)-clicked {
                animation: \(keyframeName) \(animationTiming)\(getRepeatCount(animation))\(getFillMode(animation));
            }
            .\(name)-clicked.reverse {
                animation: \(keyframeName)-reverse \(animationTiming)\(getRepeatCount(animation))\(getFillMode(animation));
                animation-fill-mode: forwards;
            }
            """
        }
        
        // For standard animations
        let properties = animation.frames.first?.animations.map { anim in
            "\(anim.property.rawValue): \(anim.to)"
        }.joined(separator: ";\n    ") ?? ""
        
        return """
        .\(name)-clicked {
            \(properties);
            transition: all \(animationTiming);
        }
        """
    }

    /// Generates CSS classes specifically for color-based click animations
    /// - Parameters:
    ///   - animation: The animation to generate color click classes for
    ///   - timing: The timing string for the animation
    /// - Returns: A string containing the CSS class definitions
    private func buildColorClickClass(_ animation: ResolvedAnimation, timing: String) -> String {
        let animationTiming = getAnimationTiming(animation)
        let keyframeName = "\(name)-\(animation.trigger.rawValue)"
        let reverseClass = animation.autoreverses ? """
        
        .\(name)-clicked.reverse {
            animation: \(keyframeName)-reverse \(animationTiming)\(getRepeatCount(animation))\(getFillMode(animation));
        }
        """ : ""
        
        return """
        .\(name)-clicked {
            animation: \(keyframeName) \(animationTiming)\(getRepeatCount(animation))\(getFillMode(animation));
        }\(reverseClass)
        """
    }
    
    /// Generates CSS classes for hover animations
    /// - Parameter animation: The animation to generate hover classes for
    /// - Returns: A string containing the CSS class definitions
    private func buildHoverClass(_ animation: ResolvedAnimation) -> String {
        // Get all hover properties
        let hoverProperties = animation.frames.last?.animations
            .map { animation in
                "\(animation.property.rawValue): \(animation.to)"
            }
            .joined(separator: ";\n    ") ?? ""
        
        return """
        .\(name):hover {
            \(hoverProperties)
        }
        """
    }
    
    /// Builds the complete CSS output including keyframes and all classes
    /// - Returns: A string containing the complete CSS output
    func build() -> String {
        // Generate base class first and only once
        let baseClass = buildBaseClass()
        
        // Generate keyframes for non-hover animations
        let keyframes = triggerMap.filter { $0.key != .hover }
            .values
            .map(buildKeyframes)
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        
        // Build hover class
        let hoverClass = if let hoverAnimation = triggerMap[.hover] {
            buildHoverClass(hoverAnimation)
        } else {
            ""
        }
        
        // Build other trigger classes, consolidating identical animations
        var seenAnimations = Set<String>()
        let triggerClasses = triggerMap.compactMap { trigger, animation in
            let key = "\(animation.frames)_\(animation.duration)_\(animation.timing)"
            switch trigger {
            case .click:
                return seenAnimations.insert(key).inserted ? buildClickClass(animation) : ""
            case .appear:
                return seenAnimations.insert(key).inserted ? buildAppearClass(animation) : ""
            case .hover:
                return ""
            }
        }
        .filter { !$0.isEmpty }
        .joined(separator: "\n\n")
        
        // Combine all parts in specific order, ensuring base class is only included once
        // and removing any empty strings
        return [baseClass, hoverClass, keyframes, triggerClasses]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
}

/*
 When using appear animations with color transitions, the final state was being lost after the animation
 completed because the animation class (containing both the animation and final state properties) was being
 removed by the JavaScript animationend handler. The solution was to split the animation into two classes:
 one for the animation itself (-appear) and another for the final state (-appear-final). The animation
 class is removed after the animation completes, but the final state class remains, maintaining the end
 state of the animation. This approach avoids using !important and maintains clean separation between
 animation and final state properties.

 See:
 - AnimationClassGenerator.swift (buildAppearClass method)
 - Animation-Modifier.swift (animation modifier)
 - animations.js (igniteHandleAppearAnimation function)
 */
