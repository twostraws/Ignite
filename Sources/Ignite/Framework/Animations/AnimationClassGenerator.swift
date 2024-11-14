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
        let needsFillMode = animation.frames.first?.animations.contains { animation in
            let property = animation.property.lowercased()
            return property.contains("color") ||
                property == "opacity" ||
                property.contains("filter") ||
                property.contains("background")
        } ?? false
        
        return needsFillMode ? " forwards" : ""
    }

    /// Generates CSS classes for appear animations
    /// - Parameter animation: The animation to generate appear classes for
    /// - Returns: A string containing the CSS class definition
    private func buildAppearClass(_ animation: ResolvedAnimation) -> String {
        let initialOpacity = animation.frames.first?.animations
            .first { $0.property.lowercased() == "opacity" }?.from ?? "0"
        let animationTiming = "\(animation.duration)s \(animation.timing.cssValue)"
        let repeatCount = getRepeatCount(animation)
        
        return """
        .\(name)-appear {
            animation: \(name)-appear \(animationTiming)\(repeatCount);
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
        
        // Add initial states for all animations
        triggerMap.forEach { trigger, animation in
            animation.frames.first?.animations.forEach { anim in
                let property = anim.property.lowercased()
                if trigger == .appear && property == "opacity" {
                    // For appear animations, set initial opacity in base class
                    properties.insert("opacity: \(anim.from)")
                } else if trigger == .click && property.contains("color") {
                    // For click animations with color, set initial color
                    properties.insert("\(anim.property): \(anim.from)")
                }
            }
        }
        
        return """
        .\(name) {
            \(properties.sorted().joined(separator: ";\n    "))
        }
        """
    }
    
    /// Generates CSS keyframe definitions for an animation
    /// - Parameter animation: The animation to generate keyframes for
    /// - Returns: A string containing the CSS @keyframes definition
    private func buildKeyframes(_ animation: ResolvedAnimation) -> String {
        animation.generateKeyframes()
    }
    
    /// Generates CSS classes for click animations
    /// - Parameter animation: The animation to generate click classes for
    /// - Returns: A string containing the CSS class definitions
    private func buildClickClass(_ animation: ResolvedAnimation) -> String {
        let animationTiming = "\(animation.duration)s \(animation.timing.cssValue)"
        
        let hasColorAnimation = animation.frames.first?.animations.contains { anim in
            anim.property.lowercased().contains("color")
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
            "\(anim.property): \(anim.to)"
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
        let animationTiming = "\(animation.duration)s \(animation.timing.cssValue)"
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
        let transitionProperties = animation.frames.flatMap { frame in
            frame.animations.map { $0.property }
        }.joined(separator: ", ")
        
        let hoverProperties = animation.frames.last?.animations.map { animation in
            "\(animation.property): \(animation.to)"
        }.joined(separator: ";\n    ") ?? ""
        
        let animationTiming = "\(animation.duration)s \(animation.timing.cssValue)"
        
        return """
        .\(name) {
            transition: \(transitionProperties) \(animationTiming);
        }
        .\(name):hover {
            \(hoverProperties)
        }
        """
    }
    
    /// Generates all trigger-specific CSS classes
    /// - Returns: A string containing all trigger-specific CSS class definitions
    private func buildTriggerClasses() -> String {
        triggerMap.compactMap { trigger, animation in
            switch trigger {
            case .click:
                return buildClickClass(animation)
            case .appear:
                return buildAppearClass(animation)
            case .hover:
                return buildHoverClass(animation)
            }
        }.joined(separator: "\n\n")
    }
    
    /// Builds the complete CSS output including keyframes and all classes
    /// - Returns: A string containing the complete CSS output
    func build() -> String {
        let keyframes = triggerMap.values.map(buildKeyframes).joined(separator: "\n\n")
        let baseClass = buildBaseClass()
        let triggerClasses = buildTriggerClasses()
        
        return """
        \(baseClass)
        
        \(keyframes)
        
        \(triggerClasses)
        """
    }
}
