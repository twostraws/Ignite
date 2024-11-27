//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies animations or transitions to HTML elements.
struct AnimationModifier: HTMLModifier {
    /// The transition to apply, if using a CSS transition animation.
    var transition: Transition?

    /// The keyframe animation to apply, if using a keyframe-based animation.
    var animation: Animation?

    /// The direction to play the animation, if using a keyframe animation.
    var direction: AnimationDirection?

    /// The event that triggers this animation (.hover, .click, or .appear).
    var trigger: AnimationTrigger

    /// Applies the animation or transition to the provided HTML content.
    /// - Parameter content: The HTML content to animate
    /// - Returns: The modified HTML content with animation attributes applied
    func body(content: some HTML) -> any HTML {
        if let transition {
            content.applyAnimation(transition, direction: nil, trigger: trigger)
        } else if let animation {
            content.applyAnimation(animation, direction: direction, trigger: trigger)
        }
        content
    }
}

public extension HTML {
    /// Applies a transition animation to an HTML element.
    ///
    /// - Parameters:
    ///   - animation: The transition animation to apply
    ///   - trigger: The event that triggers this animation (.hover, .click, or .appear)
    /// - Returns: A modified HTML element with the animation applied
    func transition(_ transition: Transition, on trigger: AnimationTrigger) -> some HTML {
        modifier(AnimationModifier(transition: transition, trigger: trigger))
    }

    /// Applies a keyframe animation to an HTML element.
    ///
    /// - Parameters:
    ///   - animation: The keyframe animation to apply
    ///   - autoreverses: Whether the animation should play in reverse after completing
    ///   - trigger: The event that triggers this animation (.hover, .click, or .appear)
    /// - Returns: A modified HTML element with the animation applied
    func animation(_ animation: Animation, direction: AnimationDirection? = nil, on trigger: AnimationTrigger) -> some HTML {
        modifier(AnimationModifier(animation: animation, direction: direction, trigger: trigger))
    }

    /// Applies an animation to an HTML element and manages the necessary container structure.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply, conforming to Animatable protocol
    ///   - direction: Optional direction for keyframe animations (e.g., alternate, reverse)
    ///   - trigger: The event that triggers this animation (.hover, .click, or .appear)
    /// - Returns: The modified HTML element with animation containers and classes applied
    internal func applyAnimation(_ animation: some Animatable, direction: AnimationDirection?, trigger: AnimationTrigger) -> Self {
        var attributes = attributes
        let animationName = "animation-\(self.id)"

        // Track which containers we've already added
        let existingContainers = Set(attributes.containerAttributes.flatMap { $0.classes })

        // Extract color styles from the element and move them to the animation wrapper
        var wrapperStyles: OrderedSet<AttributeValue> = []
        if let backgroundColor = attributes.styles.first(where: { $0.name == "background-color" }) {
            wrapperStyles.append(backgroundColor)
            attributes.styles.removeAll { $0.name == "background-color" }
        }
        if let background = attributes.styles.first(where: { $0.name == "background" }) {
            wrapperStyles.append(background)
            attributes.styles.removeAll { $0.name == "background" }
        }
        if let color = attributes.styles.first(where: { $0.name == "color" }) {
            wrapperStyles.append(color)
            attributes.styles.removeAll { $0.name == "color" }
        }

        // Check for existing animations with this trigger
        let existingAnimation = AnimationManager.default.getAnimation(for: self.id, trigger: trigger)

        // Prepare the animation for registration
        var modifiedAnimation: any Animatable = animation
        if let basicAnim = animation as? Transition {
            var copy = basicAnim

            // Combine with existing animation if present
            if let existing = existingAnimation as? Transition {
                copy.data.append(contentsOf: existing.data)
            }

            modifiedAnimation = copy
        } else if let keyframeAnim = animation as? Animation {
            var copy = keyframeAnim
            if let direction {
                copy.direction = direction
            }

            // Combine with existing keyframe animation if present
            if let existing = existingAnimation as? Animation {
                copy.frames.append(contentsOf: existing.frames)
            }

            modifiedAnimation = copy
        }

        modifiedAnimation.trigger = trigger

        if trigger == .click || trigger == .hover {
            modifiedAnimation.staticProperties.append(.init(name: "cursor", value: "pointer"))
        }

        // Register the combined animation
        AnimationManager.default.register(modifiedAnimation, for: self.id)

        // Get all animations for this element sorted by modifier order
        let sortedTriggers = AnimationManager.default.getAnimationTriggers(for: self.id)

        // The order of these parent containers is *very* important to ensure no overwriting
        for trigger in sortedTriggers {
            switch trigger {
            case .click where !existingContainers.contains("click-\(self.id)"):
                // Add click handler to a new container, or the appear container
                // if it exists to avoid duplicate class assignments
                if !existingContainers.contains(animationName) {
                    attributes.append(containerAttributes: ContainerAttributes(
                        type: .click,
                        classes: [animationName],
                        styles: wrapperStyles,
                        events: [Event(name: "onclick", actions: [CustomAction("igniteToggleClickAnimation(this)")])]
                    ))
                } else {
                    // When the JS function igniteToggleClickAnimation(this) is called,
                    // it needs to toggle classes on the container that holds both the base animation
                    // and the click-specific styles. If we put the handler on the click-specific
                    // inner container, it wouldn't be able to affect its parent.
                    if let index = attributes.containerAttributes.firstIndex(where: { $0.classes.contains(animationName) }) {
                        let updatedContainers = attributes.containerAttributes.enumerated().map { i, element in
                            if i == index {
                                var modified = element
                                modified.type = .click
                                modified.events.insert(Event(name: "onclick", actions: [CustomAction("igniteToggleClickAnimation(this)")]))
                                return modified
                            }
                            return element
                        }
                        attributes.containerAttributes = OrderedSet(updatedContainers)
                    }
                }

                // Inner click-specific container
                attributes.append(containerAttributes: ContainerAttributes(
                    type: .animation,
                    classes: ["click-\(self.id)"]
                ))

            case .hover where !existingContainers.contains("\(animationName)-hover"):
                // Create outer transform container
                attributes.append(containerAttributes: ContainerAttributes(
                    type: .transform,
                    classes: ["\(animationName)-transform"],
                    styles: [AttributeValue(name: "transform-style", value: "preserve-3d")]
                ))

                // Add hover effects container
                var classes: OrderedSet<String> = ["\(animationName)-hover"]
                if let animation = animation as? Animation, animation.fillMode == .backwards || animation.fillMode == .both {
                    classes.append("fill-\(self.id)-\(animation.fillMode.rawValue)")
                }
                attributes.append(containerAttributes: ContainerAttributes(
                    type: .animation,
                    classes: classes,
                    styles: wrapperStyles
                ))

            case .appear where !existingContainers.contains(animationName):
                attributes.append(containerAttributes: ContainerAttributes(
                    type: .animation,
                    classes: [animationName],
                    styles: wrapperStyles
                ))

            default: break
            }
        }

        AttributeStore.default.merge(attributes, intoHTML: self.id, removing: wrapperStyles)
        return self
    }
}
