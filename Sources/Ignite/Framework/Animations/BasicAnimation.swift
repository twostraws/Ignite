//
// BasicAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The main animation configuration type that provides a flexible way to define CSS animations
public struct BasicAnimation: Animation {
    /// The CSS properties being animated and their values
    var data: [AnimationData]
    /// Additional non-animated CSS properties
    public var staticProperties: OrderedSet<AttributeValue> = []
    /// The event that triggers this animation (hover, click, or appear)
    public var trigger: AnimationTrigger = .hover
    
    public init(@AnimationBuilder content: () -> [AnimationData]) {
        self.data = content()
    }
}

public extension BasicAnimation {
    /// Combines the current animation with additional animation data.
    internal func combined(with values: [AnimationData]) -> Self {
        var copy = self
        copy.data.append(contentsOf: values)
        return copy
    }

    /// Adjusts the animation speed by dividing the duration
    func speed(_ speed: Double) -> Self {
        guard let lastIndex = data.indices.last else { return self }
        var copy = self
        copy.data[lastIndex].duration = (copy.data[lastIndex].duration) / speed
        return copy
    }
    
    /// Sets the animation duration in seconds
    func duration(_ duration: Double) -> Self {
        guard let lastIndex = data.indices.last else { return self }
        var copy = self
        copy.data[lastIndex].duration = duration
        return copy
    }
    
    /// Sets the delay before the animation starts
    func delay(_ delay: Double) -> Self {
        guard let lastIndex = data.indices.last else { return self }
        var copy = self
        copy.data[lastIndex].delay = delay
        return copy
    }
    
    func timing(_ function: AnimationCurve) -> Self {
        guard let lastIndex = data.indices.last else { return self }
        var copy = self
        copy.data[lastIndex].timing = function
        return copy
    }
    
    /// Sets a specific number of times to repeat the animation
    func repeatCount(_ count: Double, autoreverses: Bool = true) -> Self {
        guard let lastIndex = data.indices.last else { return self }
        var copy = self
        copy.data[lastIndex].repeatCount = count
        copy.data[lastIndex].autoreverses = autoreverses
        return copy
    }
}

public extension Animation where Self == BasicAnimation {
    /// Creates a fade-in animation that transitions opacity from 0 to 1.
    static var fadeIn: Self {
        BasicAnimation {
            AnimationData(.opacity, from: "0", to: "1")
        }
        .duration(0.35)
        .timing(.automatic)
    }
    
    /// Adds a fade-in effect to the current animation
    func fadeIn() -> Self {
        self.combined(with: [AnimationData(.opacity, from: "0", to: "1")])
    }
    
    /// Creates a fade-out animation that transitions opacity from 1 to 0.
    static var fadeOut: Self {
        BasicAnimation {
            AnimationData(.opacity, from: "1", to: "0")
        }
        .duration(0.35)
        .timing(.automatic)
    }
    
    /// Adds a fade-out effect to the current animation
    func fadeOut() -> Self {
        self.combined(with: [AnimationData(.opacity, from: "1", to: "0")])
    }
    
    /// Creates an animation that slides content in from a specified edge.
    static func slideIn(from edge: Edge) -> Self {
        let (property, from) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return BasicAnimation {
            AnimationData(.transform, from: "\(property)(\(from))", to: "\(property)(0)")
        }
        .duration(0.35)
        .timing(.automatic)
    }
    
    /// Adds a slide-in effect to the current animation
    func slideIn(from edge: Edge) -> Self {
        let (property, from) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return self.combined(with: [
            AnimationData(.transform, from: "\(property)(\(from))", to: "\(property)(0)")
        ])
    }
    
    /// Creates an animation that slides content out to a specified edge.
    static func slideOut(to edge: Edge) -> Self {
        let (property, to) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return BasicAnimation {
            AnimationData(.transform, from: "\(property)(0)", to: "\(property)(\(to))")
        }
        .duration(0.35)
        .timing(.automatic)
    }
    
    /// Adds a slide-out effect to the current animation
    func slideOut(to edge: Edge) -> Self {
        let (property, to) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return self.combined(with: [
            AnimationData(.transform, from: "\(property)(0)", to: "\(property)(\(to))")
        ])
    }
    
    /// Creates a rotation animation by specified angle.
    static func rotate(_ angle: Angle, anchor: AnchorPoint = .center) -> Self {
        BasicAnimation {
            AnimationData(.transform, from: "rotate(0deg)", to: "rotate(\(angle.value))")
            AnimationData(.transformOrigin, from: anchor.value, to: anchor.value)
        }
    }
    
    /// Adds a rotation effect to the current animation
    func rotate(_ angle: Angle, anchor: AnchorPoint = .center) -> Self {
        self.combined(with: [
            AnimationData(.transform, from: "rotate(0deg)", to: "rotate(\(angle.value))"),
            AnimationData(.transformOrigin, from: anchor.value, to: anchor.value)
        ])
    }
    
    /// Creates a scale animation between two values.
    static func scale(from: Double = 0.8, to: Double = 1.0) -> Self {
        BasicAnimation {
            AnimationData(.transform, from: "scale(\(from))", to: "scale(\(to))")
        }
    }
    
    /// Adds a scale effect to the current animation
    func scale(from: Double = 0.8, to: Double = 1.0) -> Self {
        self.combined(with: [
            AnimationData(.transform, from: "scale(\(from))", to: "scale(\(to))")
        ])
    }
    
    /// Creates a color transition animation.
    static func color(_ color: Color) -> Self {
        BasicAnimation {
            AnimationData(.color, value: "\(color.description) !important")
        }
    }
    
    /// Adds a color transition to the current animation
    func color(_ color: Color) -> Self {
        self.combined(with: [
            AnimationData(.color, value: "\(color.description) !important")
        ])
    }
    
    /// Creates a background color transition animation.
    static func backgroundColor(_ color: Color) -> Self {
        BasicAnimation {
            AnimationData(.backgroundColor, value: color.description)
        }
    }
    
    /// Adds a background color transition to the current animation
    func backgroundColor(_ color: Color) -> Self {
        self.combined(with: [
            AnimationData(.backgroundColor, value: color.description)
        ])
    }
    
    /// Creates a blur effect animation.
    static func blur(radius: Double) -> Self {
        BasicAnimation {
            AnimationData(.filter, from: "blur(0px)", to: "blur(\(radius)px)")
        }
    }
    
    /// Adds a blur effect to the current animation
    func blur(radius: Double) -> Self {
        self.combined(with: [
            AnimationData(.filter, from: "blur(0px)", to: "blur(\(radius)px)")
        ])
    }
    
    /// Creates a bouncing animation.
    static var bounce: Self {
        BasicAnimation {
            AnimationData(.transform, from: "translateY(0)", to: "translateY(-20px)")
        }
        .duration(0.5)
        .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
        .repeatCount(1, autoreverses: true)
    }
    
    /// Adds a bounce effect to the current animation
    func bounce() -> Self {
        self.combined(with: [
            AnimationData(.transform, from: "translateY(0)", to: "translateY(-20px)")
        ])
        .duration(0.5)
        .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
        .repeatCount(1, autoreverses: true)
    }
    
    /// Creates a shaking animation.
    static var wiggle: Self {
        BasicAnimation {
            AnimationData(.transform, from: "translateX(0)", to: "translateX(10px)")
        }
        .duration(0.5)
        .timing(.automatic)
        .repeatCount(3, autoreverses: true)
    }
    
    /// Adds a wiggle effect to the current animation
    func wiggle() -> Self {
        self.combined(with: [
            AnimationData(.transform, from: "translateX(0)", to: "translateX(10px)")
        ])
        .duration(0.5)
        .timing(.automatic)
        .repeatCount(3, autoreverses: true)
    }
    
    /// Creates a 3D flip animation in the specified direction.
    static func flip(_ direction: Rotation = .right) -> Self {
        let (axis, degrees) = switch direction {
        case .right: ("Y", "360deg")
        case .left: ("Y", "-360deg")
        case .up: ("X", "-360deg")
        case .down: ("X", "360deg")
        }
        
        return BasicAnimation {
            AnimationData(
                .transform,
                from: "perspective(400px) rotate\(axis)(0)",
                to: "perspective(400px) rotate\(axis)(\(degrees))")
        }
        .duration(0.5)
        .timing(.easeInOut)
    }
    
    /// Adds a 3D flip effect to the current animation
    func flip(_ direction: Rotation = .right) -> Self {
        let (axis, degrees) = switch direction {
        case .right: ("Y", "360deg")
        case .left: ("Y", "-360deg")
        case .up: ("X", "-360deg")
        case .down: ("X", "360deg")
        }
        
        return self.combined(with: [
            AnimationData(
                .transform,
                from: "perspective(400px) rotate\(axis)(0)",
                to: "perspective(400px) rotate\(axis)(\(degrees))")
        ])
        .duration(0.5)
        .timing(.easeInOut)
    }
}
