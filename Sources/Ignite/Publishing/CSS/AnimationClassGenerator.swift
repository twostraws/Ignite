//
// AnimationClassGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A utility type that generates CSS classes for different types of animations.
///
/// `AnimationClassGenerator` converts Ignite animations into CSS classes, handling different
/// trigger types (hover, click, appear) and generating appropriate keyframes and transition rules.
struct AnimationClassGenerator {
    /// The event that triggers this animation.
    var trigger: AnimationTrigger

    /// The animation to execute when triggered.
    var animation: any Animatable

    /// Holds CSS properties and transitions for both clicked and unclicked states,
    /// separated into transform and non-transform properties. Transform properties
    /// need their own container to avoid conflicts with other transforms and maintain
    /// proper 3D rendering, while non-transform properties can be safely nested
    /// in child elements.
    struct ClickAnimationProperties {
        var nonTransformTransitions: [String] = []
        var nonTransformProperties: [String] = []
        var transformTransitions: [String] = []
        var transformProperties: [String] = []
        var unclickedNonTransformProperties: [String] = []
        var unclickedTransformProperties: [String] = []
    }

    /// Formats CSS output for click animations, creating separate rules for transform and non-transform properties
    /// - Parameter properties: The collected CSS properties and transitions
    /// - Returns: A string containing the formatted CSS classes
    func buildClickOutput(_ properties: ClickAnimationProperties, id animationID: String) -> String {
        var output = ""
        let baseClass = "animation-" + animationID
        if !properties.nonTransformProperties.isEmpty {
            output += """
            .\(baseClass).clicked .click-\(animationID) {
                transition: \(properties.nonTransformTransitions.joined(separator: ", "));
                \(properties.nonTransformProperties.joined(separator: ";\n        "));
            }

            .\(baseClass).unclicked .click-\(animationID)  {
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
            .\(baseClass).clicked {
                transition: \(properties.transformTransitions.joined(separator: ", "));
                \(properties.transformProperties.joined(separator: ";\n        "));
            }

            .\(baseClass).unclicked {
                transition: \(properties.transformTransitions.joined(separator: ", "));
                \(properties.unclickedTransformProperties.joined(separator: ";\n        "));
            }
            """
        }

        return output
    }

    /// Creates a CSS animation timing string including duration, delay, timing function, and iteration count
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function delay iteration-count"
    func getAnimationTiming(_ animation: Animation) -> String {
        var components: [String] = [
            "\(animation.duration)s",
            animation.timing.css
        ]

        if animation.delay > 0 {
            components.append("\(animation.delay)s")
        }

        return components.joined(separator: " ")
    }

    /// Builds the complete CSS output including keyframes and all classes
    /// - Returns: A string containing the complete CSS output
    func build() -> String {
        // Base class needs an animation for static properties
        var components: [String] = [buildBaseClass(animation)]

        // Add hover animations if present
        if trigger == .hover {
            if let transition = animation as? Transition {
                components.append(buildTransitionHoverClass(transition))
            } else if let animation = animation as? Animation {
                components.append(buildKeyframeHoverClass(animation))
            }
        }

        // Add appear animations if present
        if trigger == .appear {
            if let transition = animation as? Transition {
                components.append(buildTransitionAppearClass(transition))
            } else if let animation = animation as? Animation {
                components.append(buildAppearKeyframes(animation))
            }
        }

        // Add click animations if present
        if trigger == .click {
            if let transition = animation as? Transition {
                components.append(buildTransitionClickClass(transition))
            } else if let animation = animation as? Animation {
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
        var baseProperties = Set<String>()

        if trigger == .appear {
            if let transition = animation as? Transition {
                baseProperties.formUnion(buildBaseTransitionClass(transition))
            } else if let animation = animation as? Animation {
                baseProperties.formUnion(buildBaseKeyframeClass(animation))
            }
        }

        if trigger == .click {
            baseProperties.insert("cursor: pointer")
        }

        let appearedProperties = getAppearedProperties()
        let joinedProperties = baseProperties.joined(separator: ";\n        ")
        let baseClassProperties = baseProperties.isEmpty ? "" : "\n        \(joinedProperties);\n    "
        let className = "animation-" + animation.id

        let baseClass = if baseClassProperties.isEmpty {
            ""
        } else {
            ".\(className) {\(baseClassProperties)}"
        }

        // Only add appeared class if we have properties to set
        if !appearedProperties.isEmpty {
            let joinedAppearedProperties = appearedProperties.joined(separator: ";\n        ")

            return baseClass + "\n\n" + """
            .\(className).appeared {
                \(joinedAppearedProperties);
            }
            """
        }

        return baseClass
    }

    /// Generates CSS keyframe animations specifically for appear trigger animations.
    /// - Parameter animation: The animation to generate appear keyframes for
    /// - Returns: A string containing the CSS @keyframes definition for the appear animation,
    /// or an empty string if the animation isn't an `Animation`
    private func buildAppearKeyframes(_ animation: Animation) -> String {
        let timing = getAnimationTiming(animation)
        let keyframeContent = animation.frames.map { frame in
            let properties = frame.styles
                .map { "\($0.property): \($0.value)" }
                .joined(separator: ";\n                ")

            return """
                \(frame.position.roundedValue.asString()) {
                    \(properties)
                }
            """
        }.joined(separator: "\n        ")

        let repeatCount = animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount)
        let repeatString = animation.repeatCount != 1 ? "animation-iteration-count: \(repeatCount);" : ""
        let baseClass = "animation-" + animation.id

        return """
        .\(baseClass).appeared {
            animation: \(baseClass)-appear \(timing);
            animation-fill-mode: \(animation.fillMode);
            animation-direction: \(animation.direction);
            \(repeatString)
        }

        @keyframes \(baseClass)-appear {
            \(keyframeContent)
        }
        """
    }

    /// Extracts the final CSS property values for appear animations.
    /// - Returns: An array of CSS property declarations, or an empty array if no appear animation exists.
    private func getAppearedProperties() -> [String] {
        guard trigger == .appear else { return [] }
        var properties: [String] = []

        if let transition = animation as? Transition {
            properties = transition.data.map { data in
                "\(data.property): \(data.final)"
            }
        }

        return properties
    }
}
