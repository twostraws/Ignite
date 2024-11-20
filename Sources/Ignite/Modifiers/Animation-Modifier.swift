//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    func animation(_ animation: some Animation, autoreverses: Bool = false, on trigger: AnimationTrigger) -> Self {
        var attributes = attributes
        let animationName = "animation-\(self.id)"
        
        // Check for existing animations with this trigger
        let existingAnimation = AnimationManager.default.getAnimation(for: self.id, trigger: trigger)
        
        // Prepare the animation for registration
        var modifiedAnimation: any Animation
        if let basicAnim = animation as? BasicAnimation {
            var copy = basicAnim
            copy.trigger = trigger
            copy.data = basicAnim.data.map { value in
                var valueCopy = value
                valueCopy.autoreverses = autoreverses
                return valueCopy
            }
            
            // Combine with existing animation if present
            if let existing = existingAnimation as? BasicAnimation {
                copy.data.append(contentsOf: existing.data)
            }
            
            modifiedAnimation = copy
        } else if let keyframeAnim = animation as? KeyframeAnimation {
            var copy = keyframeAnim
            copy.trigger = trigger
            copy.autoreverses = autoreverses
            
            // Combine with existing keyframe animation if present
            if let existing = existingAnimation as? KeyframeAnimation {
                copy.frames.append(contentsOf: existing.frames)
            }
            
            modifiedAnimation = copy
        } else {
            var copy = animation
            copy.trigger = trigger
            modifiedAnimation = copy
        }
        
        if trigger == .click || trigger == .hover {
            modifiedAnimation.staticProperties.append(.init(name: "cursor", value: "pointer"))
        }
        
        // Register the combined animation
        AnimationManager.default.register(modifiedAnimation, for: self.id)

        // Add scale wrapper (innermost) for hover animations
        if trigger == .hover {
            attributes.append(containerAttributes: ContainerAttributes(
                classes: ["\(animationName)-hover"]
            ))
        }
        
        // Add click-specific data attributes
        if trigger == .click {
            attributes.events.insert(Event(name: "onclick", actions: [CustomAction("toggleClickAnimation(this)")]))
        }

        // Add base class
        attributes.append(classes: [animationName])
        
        AttributeStore.default.merge(attributes, intoHTML: self.id)
        return self
    }
}
