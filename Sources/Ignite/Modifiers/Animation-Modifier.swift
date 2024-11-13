//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Applies an animation to an HTML element.
    /// - Parameters:
    ///   - animation: The animation to apply
    ///   - trigger: When the animation should occur (click, hover, or appear)
    /// - Returns: The modified HTML element with animation support
    func animation(_ animation: Animation, on trigger: AnimationTrigger) -> Self {
        let animationName = "animation-\(id)"
        var attributes = attributes
        attributes.append(styles: .init(name: "display", value: "inline-block"))
        
        // Add base animation class and register animation
        attributes.classes.append(animationName)
        attributes.customAttributes.insert(.init(name: "id", value: id))
        
        // Find all color-related animations and set their initial values
        for property in animation.properties where property.name.contains("color") {
            attributes.styles.append(.init(name: property.name, value: property.initial))
        }
        
        AnimationManager.shared.registerAnimation(animation, for: id, trigger: trigger)
        
        // Add trigger-specific attributes
        switch trigger {
        case .click:
            attributes.styles.append(.init(name: "cursor", value: "pointer"))
            var clickClasses = attributes.data
                .first(where: { $0.name == "active-classes" })?
                .value
                .split(separator: " ")
                .map(String.init) ?? []
            
            clickClasses = Array(Set(clickClasses + [animationName]))
            attributes.data = attributes.data.filter { $0.name != "active-classes" }
            attributes.data.insert(.init(
                name: "active-classes",
                value: clickClasses.joined(separator: " ")
            ))
            
            let toggleAction = CustomAction("handleClickAnimation.call(this, event)")
            attributes.events.insert(.init(name: "onclick", actions: [toggleAction]))
            
        case .hover:
            attributes.data.insert(.init(name: "hover-class", value: animationName))
            attributes.styles.append(.init(name: "cursor", value: "pointer"))
            
        case .appear:
            var appearClasses = attributes.data
                .first(where: { $0.name == "appear-classes" })?
                .value
                .split(separator: " ")
                .map(String.init) ?? []
            
            appearClasses.append(animationName)
            attributes.data = attributes.data.filter { $0.name != "appear-classes" }
            attributes.data.insert(.init(
                name: "appear-classes",
                value: appearClasses.joined(separator: " ")
            ))
        }
        
        AttributeStore.default.merge(attributes, intoHTML: id)
        return self
    }
}

/// Combines multiple animation properties into a single CSS string, handling deduplication and proper formatting for use in style attributes.
/// - Parameters:
///   - props: Array of animation property values to combine
///   - useInitial: Whether to use the initial or final values of the properties
/// - Returns: A formatted CSS property string
private func generatePropertyString(_ properties: [AnimationValue], useInitial: Bool) -> String {
    // Group properties by name to prevent duplicates
    let groupedProperties = Dictionary(grouping: properties, by: { $0.name })
        .mapValues { $0.last! } // Take the last value for each property name
        .values
    
    return groupedProperties.map { property in
        "\(property.name): \(useInitial ? property.initial : property.final)"
    }.joined(separator: "; ")
}
