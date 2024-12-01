//
// AnimationClassGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import OrderedCollections

/// A utility type that generates CSS classes for different types of animations.
///
/// `AnimationClassGenerator` converts Ignite animations into CSS classes, handling different
/// trigger types (hover, click, appear) and generating appropriate keyframes and transition rules.
struct AnimationClassGenerator {
    /// The ID of the element receiving animations
    let elementID: String

    /// A mapping of trigger types to their corresponding resolved animations
    let triggerMap: OrderedDictionary<AnimationTrigger, any Animatable>

    /// The base name for the generated CSS classes
    private var name: String { "animation-" + elementID }

    /// Holds CSS properties and transitions for both clicked and unclicked states, separated into transform and non-transform properties.
    /// Transform properties need their own container to avoid conflicts with other transforms and maintain proper 3D rendering,
    /// while non-transform properties can be safely nested in child elements.
    private struct ClickAnimationProperties {
        var nonTransformTransitions: [String] = []
        var nonTransformProperties: [String] = []
        var transformTransitions: [String] = []
        var transformProperties: [String] = []
        var unclickedNonTransformProperties: [String] = []
        var unclickedTransformProperties: [String] = []
    }

    /// Generates CSS classes for click-triggered transitions, separating transform and non-transform properties
    /// - Parameter transition: The transition animation to convert to CSS
    /// - Returns: A string containing the CSS classes for clicked and unclicked states
    private func buildTransitionClickClass(_ transition: Transition) -> String {
        var properties = ClickAnimationProperties()

        for data in transition.data {
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            let timing = "\(data.duration)s \(data.timing.css)\(delay)"

            if data.property == .transform {
                properties.transformTransitions.append("\(data.property.rawValue) \(timing)")
                properties.transformProperties.append("\(data.property.rawValue): \(data.final)")
                properties.unclickedTransformProperties.append("\(data.property.rawValue): \(data.initial)")
            } else {
                properties.nonTransformTransitions.append("\(data.property.rawValue) \(timing)")
                properties.nonTransformProperties.append("\(data.property.rawValue): \(data.final)")
                properties.unclickedNonTransformProperties.append("\(data.property.rawValue): \(data.initial)")
            }
        }

        return buildClickOutput(properties)
    }

    /// Formats CSS output for click animations, creating separate rules for transform and non-transform properties
    /// - Parameter properties: The collected CSS properties and transitions
    /// - Returns: A string containing the formatted CSS classes
    private func buildClickOutput(_ properties: ClickAnimationProperties) -> String {
        var output = ""

        if !properties.nonTransformProperties.isEmpty {
            output += """
            .\(name).clicked .click-\(elementID) {
                transition: \(properties.nonTransformTransitions.joined(separator: ", "));
                \(properties.nonTransformProperties.joined(separator: ";\n        "));
            }

            .\(name).unclicked .click-\(elementID)  {
                transition: \(properties.nonTransformTransitions.joined(separator: ", "));
                \(properties.unclickedNonTransformProperties.joined(separator: ";\n        "));
            }
            """
        }
        
        if !properties.transformProperties.isEmpty {
            if !output.isEmpty {
                output += "\n\n"
            }

            output += """
            .\(name).clicked {
                transition: \(properties.transformTransitions.joined(separator: ", "));
                \(properties.transformProperties.joined(separator: ";\n        "));
            }

            .\(name).unclicked {
                transition: \(properties.transformTransitions.joined(separator: ", "));
                \(properties.unclickedTransformProperties.joined(separator: ";\n        "));
            }
            """
        }

        return output
    }

    /// Generates a CSS timing string for a transition, combining duration, delay, and timing function.
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function" where X is the duration in seconds
    private func getTransitionTiming(_ transition: Transition) -> [String] {
        return transition.data.map { data in
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            return "\(data.duration)s \(data.timing.css)\(delay)"
        }
    }

    /// Creates a CSS animation timing string including duration, delay, timing function, and iteration count
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function delay iteration-count"
    private func getAnimationTiming(_ animation: Animation) -> String {
        var components: [String] = [
            "\(animation.duration)s",
            animation.timing.css
        ]

        if animation.delay > 0 {
            components.append("\(animation.delay)s")
        }

        return components.joined(separator: " ")
    }

    /// Generates the base CSS properties for a keyframe animation
    /// - Parameter animation: The keyframe animation to process
    /// - Returns: A set of CSS properties including animation name and timing
    private func buildBaseKeyframeClass(_ animation: Animation) -> Set<String> {
        var baseProperties: Set<String> = ["cursor: pointer"]
        let timing = getAnimationTiming(animation)
        baseProperties.insert("animation: \(name)-appear \(timing)")
        return baseProperties
    }

    /// Creates CSS classes and keyframe definitions for hover-triggered animations
    /// - Parameter animation: The keyframe animation to convert to CSS
    /// - Returns: A string containing both the CSS class and @keyframes definition
    private func buildKeyframeHoverClass(_ animation: Animation) -> String {
        let timing = getAnimationTiming(animation)
        let iterationCount = animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount)

        // Build initial state for .backwards or .both
        let baseState = if animation.fillMode == .backwards || animation.fillMode == .both {
            animation.frames.last?.animations
                .map { "\($0.property.rawValue): \($0.final)" }
                .joined(separator: ";\n            ")
        } else if animation.fillMode == .forwards || animation.fillMode == .both {
            animation.frames.first?.animations
                .map { "\($0.property.rawValue): \($0.final)" }
                .joined(separator: ";\n            ")
        } else {
            ""
        }

        // Build post-hover state for .forwards or .both
        let postHoverState = if animation.fillMode == .forwards || animation.fillMode == .both {
            animation.frames.first?.animations
                .map { "\($0.property.rawValue): \($0.final)" }
                .joined(separator: ";\n            ")
        } else {
            ""
        }

        // Add fill mode class if needed
        let fillModeClass = if animation.fillMode == .backwards || animation.fillMode == .both {
            """

            .\(name)-hover.fill-\(elementID)-\(animation.fillMode.rawValue) {
                animation: \(name)-hover \(timing) \(animation.direction.rawValue) \(animation.fillMode.rawValue)\(animation.repeatCount != 1 ? " " + iterationCount : "");
                animation-play-state: paused;
            }

            .\(name)-hover.fill-\(elementID)-\(animation.fillMode.rawValue):hover {
                animation-play-state: running;
            }
            """
        } else {
            ""
        }

        return """
        .\(name)-hover {
            transform-style: preserve-3d;
            \(baseState ?? "")
        }

        .\(name)-hover:hover {
            animation: \(name)-hover \(timing) \(animation.direction.rawValue)\(animation.repeatCount != 1 ? " " + iterationCount : "");
        }

        .\(name)-hover:not(:hover) {
            \(postHoverState ?? "")
        }
        \(fillModeClass)

        @keyframes \(name)-hover {
            \(buildKeyframeContent(animation))
        }
        """
    }

    /// Generates the keyframe content for an animation by mapping frame properties to CSS keyframe syntax
    /// - Parameter animation: The animation containing frames to convert
    /// - Returns: A string containing the formatted keyframe rules
    private func buildKeyframeContent(_ animation: Animation) -> String {
        animation.frames.map { frame in
            let properties = frame.animations
                .map { "\($0.property.rawValue): \($0.final)" }
                .joined(separator: ";\n                ")
            
            return """
                    \(frame.position.roundedValue.asString()) {
                        \(properties)
                    }
            """
        }.joined(separator: "\n        ")
    }

    /// Creates CSS classes for click-triggered keyframe animations, handling transform and non-transform properties separately
    /// - Parameter animation: The keyframe animation to convert to CSS
    /// - Returns: A string containing the CSS classes for clicked and unclicked states
    private func buildKeyframeClickClass(_ animation: Animation) -> String {
        guard let firstFrame = animation.frames.first,
              let lastFrame = animation.frames.last else { return "" }

        var properties = ClickAnimationProperties()
        let timing = getAnimationTiming(animation)

        // Build common animation properties
        var animationProperties = [
            "animation-fill-mode: \(animation.fillMode.rawValue)",
            "animation-direction: \(animation.direction.rawValue)"
        ]

        if animation.repeatCount != 1 {
            animationProperties.append("animation-iteration-count: \(animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount))")
        }

        // Add transitions for all unique properties
        let allProperties = Set(animation.frames.flatMap { frame in
            frame.animations.map { $0.property }
        })

        for property in allProperties {
            if property == .transform {
                properties.transformTransitions.append("\(property.rawValue) \(timing)")
            } else {
                properties.nonTransformTransitions.append("\(property.rawValue) \(timing)")
            }
        }

        // Add final values from last frame
        for anim in lastFrame.animations {
            if anim.property == .transform {
                properties.transformProperties.append("\(anim.property.rawValue): \(anim.final)")
            } else {
                properties.nonTransformProperties.append("\(anim.property.rawValue): \(anim.final)")
            }
        }

        // Add initial values from first frame
        for anim in firstFrame.animations {
            if anim.property == .transform {
                properties.unclickedTransformProperties.append("\(anim.property.rawValue): \(anim.final)")
            } else {
                properties.unclickedNonTransformProperties.append("\(anim.property.rawValue): \(anim.final)")
            }
        }

        return buildClickOutput(properties)
    }

    /// Generates base CSS properties for transition animations including cursor and initial property values
    /// - Parameter transition: The transition animation to process
    /// - Returns: A set of CSS properties including transitions and initial values
    private func buildBaseTransitionClass(_ transition: Transition) -> Set<String> {
        var baseProperties: Set<String> = ["cursor: pointer"]
        let timing = getTransitionTiming(transition).first ?? "0.35s ease"
        
        // Set initial values for all properties
        for data in transition.data {
            baseProperties.insert("\(data.property.rawValue): \(data.initial)")
        }
        
        // Add transitions for all properties in one declaration
        let transitions = transition.data.map { data in
            "\(data.property.rawValue) \(timing)"
        }.joined(separator: ", ")
        baseProperties.insert("transition: \(transitions)")
        
        return baseProperties
    }

    /// Creates CSS classes for hover-triggered transitions
    /// - Parameter transition: The transition animation to convert to CSS
    /// - Returns: A string containing hover and non-hover state CSS rules
    private func buildTransitionHoverClass(_ transition: Transition) -> String {
        let transformProperties = transition.data.filter { $0.property == .transform }
        let otherProperties = transition.data.filter { $0.property != .transform }

        let transformTiming = transformProperties.map { data in
            "transform \(data.duration)s \(data.timing.css)"
        }.joined(separator: ", ")

        let otherTiming = otherProperties.map { data in
            "\(data.property.rawValue) \(data.duration)s \(data.timing.css)"
        }.joined(separator: ", ")

        return """
        .\(name)-transform {
            transform-style: preserve-3d;
            transition: \(transformTiming);
        }

        .\(name)-transform:hover {
            \(transformProperties.map { "transform: \($0.final)" }.joined(separator: ";\n        "))
        }

        .\(name)-hover {
            transition: \(otherTiming);
        }

        .\(name)-hover:hover {
            \(otherProperties.map { "\($0.property.rawValue): \($0.final)" }.joined(separator: ";\n        "))
        }
        """
    }

    /// Builds the complete CSS output including keyframes and all classes
    /// - Returns: A string containing the complete CSS output
    func build() -> String {
        var components: [String] = []

        // Base class needs an animation for static properties
        if let firstAnimation = triggerMap.elements.first?.value {
            components.append(buildBaseClass(firstAnimation))
        }

        // Add hover animations if present
        if let hoverAnim = triggerMap[.hover] {
            if let transition = hoverAnim as? Transition {
                components.append(buildTransitionHoverClass(transition))
            } else if let animation = hoverAnim as? Animation {
                components.append(buildKeyframeHoverClass(animation))
            }
        }

        // Add appear animations if present
        if let appearAnim = triggerMap[.appear] {
            if let transition = appearAnim as? Transition {
                components.append(buildTransitionAppearClass(transition))
            } else if let animation = appearAnim as? Animation {
                components.append(buildAppearKeyframes(animation))
            }
        }

        // Add click animations if present
        if let clickAnim = triggerMap[.click] {
            if let transition = clickAnim as? Transition {
                components.append(buildTransitionClickClass(transition))
            } else if let animation = clickAnim as? Animation {
                components.append(buildKeyframeClickClass(animation))
            }
        }

        return components
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }

    /// Generates the base CSS class containing common properties and static properties
    /// - Parameter animation: The animation containing static properties to include in the base class
    /// - Returns: A string containing the base CSS class definition and optional appeared state
    ///
    /// This method:
    /// 1. Includes static properties from the provided animation (e.g., cursor: pointer)
    /// 2. Adds base transition or keyframe properties if an appear animation exists
    /// 3. Optionally includes an .appeared class if appear properties are present
    /// 4. Formats the output to avoid empty declarations
    private func buildBaseClass(_ animation: any Animatable) -> String {
        var baseProperties: Set<String> = Set(animation.staticProperties.map { "\($0.name): \($0.value)" })

        if let appearAnim = triggerMap[.appear] {
            if let transition = appearAnim as? Transition {
                baseProperties.formUnion(buildBaseTransitionClass(transition))
            } else if let animation = appearAnim as? Animation {
                baseProperties.formUnion(buildBaseKeyframeClass(animation))
            }
        }

        let appearedProperties = getAppearedProperties()
        let baseClass = """
        .\(name) {\(baseProperties.isEmpty ? "" : "\n        \(baseProperties.joined(separator: ";\n        "));\n    ")}
        """

        // Only add appeared class if we have properties to set
        if !appearedProperties.isEmpty {
            return baseClass + "\n\n" + """
            .\(name).appeared {
                \(appearedProperties.joined(separator: ";\n        "));
            }
            """
        }

        return baseClass
    }

    /// Generates CSS classes for appear-triggered transitions
    /// - Parameter transition: The transition animation to convert to CSS
    /// - Returns: A string containing the CSS class for the appeared state
    private func buildTransitionAppearClass(_ transition: Transition) -> String {
        let transitions: [String] = transition.data.map { data in
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            let timing = "\(data.duration)s \(data.timing.css)\(delay)"
            return "\(data.property.rawValue) \(timing)"
        }

        let properties = transition.data.map { data in
            "\(data.property.rawValue): \(data.final)"
        }

        return """
        .\(name).appeared {
            transition: \(transitions.joined(separator: ", "));
            \(properties.joined(separator: ";\n        "));
        }
        """
    }

    /// Generates CSS keyframe animations specifically for appear trigger animations.
    /// - Parameter animation: The animation to generate appear keyframes for
    /// - Returns: A string containing the CSS @keyframes definition for the appear animation, or an empty string if the animation isn't an `Animation`
    private func buildAppearKeyframes(_ animation: Animation) -> String {
        let timing = getAnimationTiming(animation)
        let keyframeContent = animation.frames.map { frame in
            let properties = frame.animations
                .map { "\($0.property.rawValue): \($0.final)" }
                .joined(separator: ";\n                ")
            
            return """
                \(frame.position.roundedValue.asString()) {
                    \(properties)
                }
            """
        }.joined(separator: "\n        ")

        return """
        .\(name).appeared {
            animation: \(name)-appear \(timing);
            animation-fill-mode: \(animation.fillMode.rawValue);
            animation-direction: \(animation.direction.rawValue);
            \(animation.repeatCount != 1 ? "animation-iteration-count: \(animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount));" : "")
        }

        @keyframes \(name)-appear {
            \(keyframeContent)
        }
        """
    }

    /// Extracts the final CSS property values for appear animations.
    /// - Returns: An array of CSS property declarations, or an empty array if no appear animation exists.
    private func getAppearedProperties() -> [String] {
        guard let appearAnim = triggerMap[.appear] else { return [] }
        var properties: [String] = []
        
        if let transition = appearAnim as? Transition {
            properties = transition.data.map { data in
                "\(data.property.rawValue): \(data.final)"
            }
        }

        return properties
    }
}
