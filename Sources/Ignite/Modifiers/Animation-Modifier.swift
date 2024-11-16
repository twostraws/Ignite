//
// Animation-Modifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    func animation(_ animation: some Animation) -> Self {
        if let resolved = animation as? ResolvedAnimation, resolved.trigger == .click {
            return self.animation(animation, on: .click)
        }
        
        // Set appear as default trigger
        return self.animation(animation, on: .appear)
    }
    
    func animation(_ animation: some Animation, autoreverses: Bool = false, on trigger: AnimationTrigger) -> Self {
        var attributes = attributes
        
        // Only apply inline-block if it's a transform animation
        if animation is BasicAnimation && (animation as? BasicAnimation)?.property == .transform {
            attributes.append(styles: .init(name: "display", value: "inline-block"))
        }
        
        // Create a resolved animation with the correct trigger
        var resolved: ResolvedAnimation
        if let r = animation as? ResolvedAnimation {
            resolved = r
            resolved.trigger = trigger
        } else if let r = AnimationBuilder.buildBlock(animation) as? ResolvedAnimation {
            resolved = r
            resolved.trigger = trigger
        } else {
            resolved = ResolvedAnimation()
        }
        
        resolved.autoreverses = autoreverses
        
        // Register the animation
        AnimationManager.shared.registerAnimation(resolved, for: self.id)
        
        // Get the potentially updated name after registration
        if let registeredAnimation = AnimationManager.shared.getAnimations(for: self.id)?[trigger] {
            resolved.name = registeredAnimation.name
        }
        
        // Add trigger-specific classes and data attributes BEFORE adding the base class
        switch trigger {
        case .click:
            let clickClasses = resolved.name + "-clicked"
            attributes.append(dataAttributes: .init(name: "click-classes", value: clickClasses))
        case .appear:
            let appearClasses = resolved.name + "-appear"
            let finalClasses = resolved.name + "-appear-final"
            attributes.append(dataAttributes: .init(name: "appear-classes", value: appearClasses))
            attributes.append(classes: [finalClasses])
        case .hover:
            break
        }
        
        // Add the base class last to ensure proper ordering
        attributes.append(classes: [resolved.name])
        AttributeStore.default.merge(attributes, intoHTML: self.id)
        
        return self
    }
}

extension Set {
    mutating func removeAll(where predicate: (Element) -> Bool) {
        self = self.filter { !predicate($0) }
    }
}
