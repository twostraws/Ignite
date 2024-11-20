//
// AnimationClassGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A utility type that generates CSS classes for different types of animations.
///
/// `AnimationClassGenerator` converts Ignite animations into CSS classes, handling different
/// trigger types (hover, click, appear) and generating appropriate keyframes and transition rules.
struct AnimationClassGenerator {
    /// The base name for the generated CSS classes
    let name: String
    
    /// A mapping of trigger types to their corresponding resolved animations
    let triggerMap: [AnimationTrigger: any Animation]
    
    /// Generates a CSS timing string for an animation, combining duration and timing function.
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function" where X is the duration in seconds
    private func getAnimationTiming(_ animation: some Animation) -> [String] {
        if let basicAnim = animation as? BasicAnimation {
            // Return timing strings for each animation value
            return basicAnim.data.map { data in
                "\(data.duration)s \(data.timing.cssValue)"
            }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return ["\(keyframeAnim.duration)s \(keyframeAnim.timing.cssValue)"]
        }
        return ["0.35s ease"]
    }
    
    /// Generates the repeat count string for CSS animation properties
    /// - Parameter animation: The animation to generate the repeat count for
    /// - Returns: A string representing the CSS animation iteration count
    private func getRepeatCount(_ animation: some Animation) -> [String] {
        if let basicAnim = animation as? BasicAnimation {
            return basicAnim.data.map { data in
                let count = data.repeatCount
                return count == .infinity ? " infinite" : " 1"
            }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            let count = keyframeAnim.repeatCount
            return [count == .infinity ? " infinite" : " 1"]
        }
        return [" 1"]
    }
    
    /// Determines if and what fill mode should be applied to the animation
    /// - Parameter animation: The animation to check for fill mode requirements
    /// - Returns: A string containing the CSS animation-fill-mode property if needed
    private func getFillMode(_ animation: some Animation) -> String {
        if let keyframeAnim = animation as? KeyframeAnimation {
            let fillMode = keyframeAnim.frames.first?.animations
                .compactMap { $0.property.fillMode.rawValue }
                .first
            return fillMode.map { " \($0)" } ?? ""
        } else if let basicAnim = animation as? BasicAnimation {
            let fillMode = basicAnim.data
                .compactMap { $0.property.fillMode.rawValue }
                .first
            return fillMode.map { " \($0)" } ?? ""
        }
        return ""
    }
    
    /// Returns an array of CSS transition property names for the given animation.
    /// - Parameter animation: The animation to extract transition properties from.
    /// - Returns: An array of strings representing CSS property names that should be transitioned.
    private func buildTransitionProperties(_ animation: some Animation) -> [String] {
        if let basicAnim = animation as? BasicAnimation {
            return basicAnim.data.map { $0.property.rawValue }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return keyframeAnim.frames.flatMap { frame in
                frame.animations.map { $0.property.rawValue }
            }
        }
        return []
    }

    /// Generates CSS classes for click animations
    /// - Parameter animation: The animation to generate click classes for
    /// - Returns: A string containing the CSS class definitions
    private func buildClickClass(_ animation: any Animation) -> String {
        // Get animation properties
        let timings = getAnimationTiming(animation)
        
        // Build transition properties
        let transitionProps: [String] = buildTransitionProperties(animation)
       
        let transitions = transitionProps.enumerated().map { index, prop -> String in
            let timing = index < timings.count ? timings[index] : "0.35s ease"
            return "\(prop) \(timing)"
        }.joined(separator: ", ")
        
        // Build clicked/unclicked properties
        var clickedProperties: [String] = []
        var unclickedProperties: [String] = []
        
        if let basicAnim = animation as? BasicAnimation {
            for data in basicAnim.data {
                clickedProperties.append("\(data.property.rawValue): \(data.final)")
                unclickedProperties.append("\(data.property.rawValue): \(data.initial)")
            }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            for frame in keyframeAnim.frames {
                for anim in frame.animations {
                    clickedProperties.append("\(anim.property.rawValue): \(anim.final)")
                    unclickedProperties.append("\(anim.property.rawValue): \(anim.initial)")
                }
            }
        }
        
        // Add transition to both states if we have any
        if !transitions.isEmpty {
            clickedProperties.append("transition: \(transitions)")
            unclickedProperties.append("transition: \(transitions)")
        }
        
        // Generate CSS
        return """
        .\(name).clicked {
            \(clickedProperties.joined(separator: ";\n        "));
        }

        .\(name).unclicked {
            \(unclickedProperties.joined(separator: ";\n        "));
        }
        """
    }
    
    /// Generates CSS classes for hover animations
    /// - Parameter animation: The animation to generate hover classes for
    /// - Returns: A string containing the CSS class definitions
    private func buildHoverClass(_ animation: any Animation) -> String {
        // Get animation properties
        let timings = getAnimationTiming(animation)
        
        // Build base wrapper class
        var wrapperProperties = ["transform-style: preserve-3d"]
        
        // Build transition properties
        let transitionProps: [String] = buildTransitionProperties(animation)
        let timing = timings.first ?? "0.35s ease"
        let transitions = transitionProps.map { "\($0) \(timing)" }.joined(separator: ", ")
        
        if !transitions.isEmpty {
            wrapperProperties.append("transition: \(transitions)")
        }
        
        // Build hover properties
        var hoverProperties: [String] = []
        
        if let basicAnim = animation as? BasicAnimation {
            for data in basicAnim.data {
                hoverProperties.append("\(data.property.rawValue): \(data.final)")
            }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            for frame in keyframeAnim.frames {
                for anim in frame.animations {
                    hoverProperties.append("\(anim.property.rawValue): \(anim.final)")
                }
            }
        }
        
        // Generate CSS
        return """
        .\(name)-hover {
            \(wrapperProperties.joined(separator: ";\n    "));
        }

        .\(name)-hover:hover {
            \(hoverProperties.joined(separator: ";\n    "));
        }
        """
    }
    
    /// Checks if the animation includes an opacity change.
    /// - Parameter animation: The animation to check for opacity changes.
    /// - Returns: `true` if the animation includes opacity changes, `false` otherwise.
    private func hasOpacityAnimation(_ animation: some Animation) -> Bool {
        if let basicAnim = animation as? BasicAnimation {
            return basicAnim.data.contains { $0.property == .opacity }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return keyframeAnim.frames.contains { frame in
                frame.animations.contains { $0.property == .opacity }
            }
        }
        return false
    }

    /// Generates CSS classes for appear animations
    /// - Parameter animation: The animation to generate appear classes for
    /// - Returns: A string containing the CSS class definition
    private func buildAppearClass(_ animation: some Animation) -> String {
        // Get animation properties
        let timings = getAnimationTiming(animation)
        
        // Get properties used by other triggers
        let hoverProperties = triggerMap[.hover].map { getAnimationProperties($0) } ?? []
        let clickProperties = triggerMap[.click].map { getAnimationProperties($0) } ?? []
        let usedProperties: Set<String> = Set(hoverProperties + clickProperties)
        
        // Get appear animation properties and filter out ones used by other triggers
        let appearProperties = getAnimationProperties(animation)
        let uniqueAppearProperties = Set(appearProperties).subtracting(usedProperties)
        
        // Build keyframes for unique properties
        let keyframeAnimations = buildUniqueKeyframes(animation, uniqueProperties: uniqueAppearProperties)
        
        // Build animations for unique properties
        var appearAnimations: [String] = []
        if let basicAnim = animation as? BasicAnimation {
            appearAnimations = basicAnim.data
                .filter { uniqueAppearProperties.contains($0.property.rawValue) }
                .map { data in
                    "\(name)-\(animation.trigger.rawValue)-\(data.property.rawValue) \(data.duration)s \(data.timing.cssValue) forwards"
                }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            appearAnimations = ["\(name)-\(animation.trigger.rawValue) \(keyframeAnim.duration)s \(keyframeAnim.timing.cssValue) forwards"]
        }
        
        // Build transition properties
        let transitionProps = buildTransitionProperties(animation)
            .filter { prop in usedProperties.contains(prop) }
        
        // Add opacity transition if needed
        var transitions = transitionProps
        if hasOpacityAnimation(animation) {
            transitions.append("opacity")
        }
        
        let transitionString = transitions
            .map { prop -> String in
                let timing = if prop == "opacity", let opacityTiming = getOpacityTiming(animation) {
                    opacityTiming
                } else {
                    timings.first ?? "0.35s ease"
                }
                return "\(prop) \(timing)"
            }
            .joined(separator: ",\n                ")
        
        // Generate CSS with conditional opacity
        var appearedProperties: [String] = []
        if let basicAnim = animation as? BasicAnimation,
           let opacityAnim = basicAnim.data.first(where: { $0.property == .opacity })
        {
            appearedProperties.append("opacity: \(opacityAnim.final)")
        } else if let keyframeAnim = animation as? KeyframeAnimation,
                  let lastFrame = keyframeAnim.frames.last?.animations.first(where: { $0.property == .opacity })
        {
            appearedProperties.append("opacity: \(lastFrame.final)")
        }

        if !transitionString.isEmpty {
            appearedProperties.append("transition: \(transitionString)")
        }
        if !appearAnimations.isEmpty {
            appearedProperties.append("animation: \(appearAnimations.joined(separator: ", "))")
        }
        
        return """
        \(keyframeAnimations)
        
        .\(name).appeared {
            \(appearedProperties.joined(separator: ";\n        "));
        }
        """
    }

    /// Returns the timing configuration for opacity animations.
    /// - Parameter animation: The animation to extract opacity timing from.
    /// - Returns: A CSS timing string (e.g. "2s ease-in-out") if opacity animation is present, nil otherwise.
    private func getOpacityTiming(_ animation: some Animation) -> String? {
        if let basicAnim = animation as? BasicAnimation,
           let opacityData = basicAnim.data.first(where: { $0.property == .opacity })
        {
            return "\(opacityData.duration)s \(opacityData.timing.cssValue)"
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return "\(keyframeAnim.duration)s \(keyframeAnim.timing.cssValue)"
        }
        return nil
    }

    /// Extracts all animatable property names from an animation.
    /// - Parameter animation: The animation to extract properties from.
    /// - Returns: An array of strings representing CSS property names used in the animation.
    private func getAnimationProperties(_ animation: some Animation) -> [String] {
        if let basicAnim = animation as? BasicAnimation {
            return basicAnim.data.map { $0.property.rawValue }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return keyframeAnim.frames.flatMap { frame in
                frame.animations.map { $0.property.rawValue }
            }
        }
        return []
    }

    /// Generates CSS keyframe definitions for properties that are unique to this animation.
    /// - Parameters:
    ///   - animation: The animation to generate keyframes for.
    ///   - uniqueProperties: Set of CSS property names that should have keyframes generated.
    /// - Returns: A string containing the complete CSS @keyframes definitions for unique properties.
    private func buildUniqueKeyframes(_ animation: some Animation, uniqueProperties: Set<String>) -> String {
        if uniqueProperties.isEmpty { return "" }
        
        if let basicAnim = animation as? BasicAnimation {
            let keyframeProps: [String] = basicAnim.data
                .filter { uniqueProperties.contains($0.property.rawValue) }
                .map { data in
                    // For background color, don't specify a 'from' state at all
                    // This will make it respect the inline style
                    let keyframeContent = if data.property == .backgroundColor {
                        """
                        to { \(data.property.rawValue): \(data.final); }
                        """
                    } else {
                        """
                        from { \(data.property.rawValue): \(data.initial); }
                        to { \(data.property.rawValue): \(data.final); }
                        """
                    }
                    
                    return """
                    @keyframes \(name)-\(animation.trigger.rawValue)-\(data.property.rawValue) {
                        \(keyframeContent)
                    }
                    """
                }
            return keyframeProps.joined(separator: "\n\n")
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            let keyframeContent = keyframeAnim.frames.map { frame in
                let properties = frame.animations
                    .filter { uniqueProperties.contains($0.property.rawValue) }
                    .map { animation in
                        "\(animation.property.rawValue): \(animation.final)"
                    }.joined(separator: ";\n            ")
                   
                return """
                    \(frame.position.roundedValue.asString()) {
                        \(properties)
                    }
                """
            }.joined(separator: "\n    ")
               
            return """
            @keyframes \(name)-\(animation.trigger.rawValue) {
                \(keyframeContent)
            }
            """
        }
        return ""
    }

    /// Generates the base CSS class containing common properties
    /// - Returns: A string containing the base CSS class definition
    private func buildBaseClass() -> String {
        // Get base properties from all animations
        var baseProperties: Set<String> = []
        
        // If we have an appear animation with opacity, set initial state
        if let appearAnim = triggerMap[.appear] as? BasicAnimation,
           let opacityAnim = appearAnim.data.first(where: { $0.property == .opacity })
        {
            baseProperties.insert("opacity: \(opacityAnim.initial)")
        } else if let appearAnim = triggerMap[.appear] as? KeyframeAnimation,
                  let firstFrame = appearAnim.frames.first?.animations.first(where: { $0.property == .opacity })
        {
            baseProperties.insert("opacity: \(firstFrame.initial)")
        }
        
        // If we have an appear animation with background color, set initial state
        if let appearAnim = triggerMap[.appear] as? BasicAnimation,
            appearAnim.data.contains(where: { $0.property == .backgroundColor })
        {
            baseProperties.insert("background-color: transparent")
        } else if let appearAnim = triggerMap[.appear] as? KeyframeAnimation,
                  let firstFrame = appearAnim.frames.first?.animations.first(where: { $0.property == .backgroundColor })
        {
            baseProperties.insert("background-color: \(firstFrame.final)")
        }
        
        // Collect static properties from all animations
        for animation in triggerMap.values {
            for prop in animation.staticProperties {
                baseProperties.insert("\(prop.name): \(prop.value)")
            }
        }
        
        // Generate CSS
        return """
        .\(name) {
            \(Array(baseProperties).joined(separator: ";\n        "));
        }
        """
    }

    /// Helper method to determine transform and color properties in hover animations
    /// - Parameter animation: The animation to check
    /// - Returns: A tuple containing booleans for transform and color presence
    private func getHoverAnimationProperties(_ animation: some Animation) -> (hasTransform: Bool, hasColor: Bool) {
        if let basicAnim = animation as? BasicAnimation {
            return (
                hasTransform: basicAnim.data.contains { $0.property == .transform },
                hasColor: basicAnim.data.contains { $0.property.isColorProperty }
            )
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            return (
                hasTransform: keyframeAnim.frames.contains { $0.animations.contains { $0.property == .transform } },
                hasColor: keyframeAnim.frames.contains { $0.animations.contains { $0.property.isColorProperty } }
            )
        }
        return (false, false)
    }
    
    /// Generates CSS keyframe definitions for any animation type.
    /// - Parameter animation: The animation to generate keyframes for
    /// - Returns: A string containing the complete CSS @keyframes definition(s)
    private func buildKeyframes(_ animation: some Animation) -> String {
        if let keyframeAnim = animation as? KeyframeAnimation {
            return buildKeyframeAnimationKeyframes(keyframeAnim)
        } else if let basicAnim = animation as? BasicAnimation {
            return buildBasicAnimationKeyframes(basicAnim)
        }
        return ""
    }

    /// Generates CSS keyframe definitions for a keyframe animation.
    /// - Parameter animation: The keyframe animation to generate keyframes for
    /// - Returns: A string containing the complete CSS @keyframes definition
    private func buildKeyframeAnimationKeyframes(_ animation: KeyframeAnimation) -> String {
        let forward = animation.frames.map { frame in
            let properties = frame.animations.map { animation in
                "\(animation.property.rawValue): \(animation.final)"
            }.joined(separator: ";\n            ")
                
            return """
                \(frame.position.roundedValue.asString()) {
                    \(properties)
                }
            """
        }.joined(separator: "\n    ")
            
        let forwardKeyframes = """
        @keyframes \(name)-\(animation.trigger.rawValue) {
            \(forward)
        }
        """
            
        if animation.trigger == .click && animation.autoreverses {
            let reverse = animation.frames.reversed().map { frame in
                let properties = frame.animations.map { animation in
                    let value = frame.position == 0% ? animation.final : animation.initial
                    return "\(animation.property.rawValue): \(value)"
                }.joined(separator: ";\n            ")
                    
                return """
                    \(frame.position.roundedValue.asString()) {
                        \(properties)
                    }
                """
            }.joined(separator: "\n    ")
                
            return """
            \(forwardKeyframes)
            
            @keyframes \(name)-\(animation.trigger.rawValue)-reverse {
                \(reverse)
            }
            """
        }
            
        return forwardKeyframes
    }

    /// Generates CSS keyframe definitions for a basic animation.
    /// - Parameter animation: The basic animation to generate keyframes for
    /// - Returns: A string containing the complete CSS @keyframes definition(s)
    private func buildBasicAnimationKeyframes(_ animation: BasicAnimation) -> String {
        return animation.data.enumerated().map { index, anim in
            let keyframeName = "\(name)-\(animation.trigger.rawValue)-\(index)"
            
            let forwardKeyframes = """
            @keyframes \(keyframeName) {
                0% {
                    \(anim.property.rawValue): \(anim.initial)
                }
                100% {
                    \(anim.property.rawValue): \(anim.final)
                }
            }
            """
            
            if animation.trigger == .click && anim.autoreverses {
                return """
                \(forwardKeyframes)
                
                @keyframes \(keyframeName)-reverse {
                    0% {
                        \(anim.property.rawValue): \(anim.final)
                    }
                    100% {
                        \(anim.property.rawValue): \(anim.initial)
                    }
                }
                """
            }
            
            return forwardKeyframes
        }.joined(separator: "\n\n")
    }
    
    /// Generates CSS classes specifically for color-based click animations
    /// - Parameters:
    ///   - animation: The animation to generate color click classes for
    ///   - timing: The timing string for the animation
    /// - Returns: A string containing the CSS class definitions
    private func buildColorClickClass(_ animation: some Animation, timing: String) -> String {
        let animationTiming = getAnimationTiming(animation)
        let keyframeName = "\(name)-\(animation.trigger.rawValue)"
        
        let hasAutoreverse = if let basicAnim = animation as? BasicAnimation {
            basicAnim.data.contains { $0.autoreverses }
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            keyframeAnim.autoreverses
        } else {
            false
        }
        
        let reverseClass = hasAutoreverse ? """
        
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
    
    /// Builds the complete CSS output including keyframes and all classes
    /// - Returns: A string containing the complete CSS output
    func build() -> String {
        let baseClass = buildBaseClass()
        let hoverClass = triggerMap[.hover].map { anim in
            buildHoverClass(anim)
        } ?? ""
        let clickClass = triggerMap[.click].map { anim in
            if let basicAnim = anim as? BasicAnimation {
                return buildClickClass(basicAnim)
            }
            return ""
        } ?? ""
        let appearClass = triggerMap[.appear].map { anim in
            buildAppearClass(anim)
        } ?? ""
        
        return [baseClass, hoverClass, appearClass, clickClass]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
}
