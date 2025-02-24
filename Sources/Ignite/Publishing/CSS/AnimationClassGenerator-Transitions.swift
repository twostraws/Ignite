//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension AnimationClassGenerator {
    /// Generates a CSS timing string for a transition, combining duration, delay, and timing function.
    /// - Parameter animation: The animation to generate timing for
    /// - Returns: A string in the format "Xs timing-function" where X is the duration in seconds
    func getTransitionTiming(_ transition: Transition) -> [String] {
        transition.data.map { data in
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            return "\(data.duration)s \(data.timing.css)\(delay)"
        }
    }

    /// Generates CSS classes for click-triggered transitions, separating transform and non-transform properties.
    /// - Parameter transition: The transition animation to convert to CSS.
    /// - Returns: A string containing the CSS classes for clicked and unclicked states.
    func buildTransitionClickClass(_ transition: Transition) -> String {
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

        return buildClickOutput(properties, id: transition.id)
    }

    /// Generates CSS classes for appear-triggered transitions
    /// - Parameter transition: The transition animation to convert to CSS
    /// - Returns: A string containing the CSS class for the appeared state
    func buildTransitionAppearClass(_ transition: Transition) -> String {
        let transitions: [String] = transition.data.map { data in
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            let timing = "\(data.duration)s \(data.timing.css)\(delay)"
            return "\(data.property.rawValue) \(timing)"
        }

        let properties = transition.data.map { data in
            "\(data.property.rawValue): \(data.final)"
        }

        let baseClass = "animation-" + transition.id

        return """
        .\(baseClass).appeared {
            transition: \(transitions.joined(separator: ", "));
            \(properties.joined(separator: ";\n        "));
        }
        """
    }

    /// Generates base CSS properties for transition animations including cursor and initial property values
    /// - Parameter transition: The transition animation to process
    /// - Returns: A set of CSS properties including transitions and initial values
    func buildBaseTransitionClass(_ transition: Transition) -> Set<String> {
        var baseProperties: Set<String> = []
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
    func buildTransitionHoverClass(_ transition: Transition) -> String {
        let transitions = transition.data.map { data in
            let delay = data.delay > 0 ? " \(data.delay)s" : ""
            return "\(data.property.rawValue) \(data.duration)s \(data.timing.css)\(delay)"
        }

        let hoverProperties = transition.data.map { data in
            "\(data.property.rawValue): \(data.final)"
        }

        let baseClass = "animation-" + transition.id

        return """
        .\(baseClass)-hover {
            transform-style: preserve-3d;
            transition: \(transitions.joined(separator: ", "));
        }

        .\(baseClass)-hover:hover {
            \(hoverProperties.joined(separator: ";\n        "));
        }
        """
    }
}
