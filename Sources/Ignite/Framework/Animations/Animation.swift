//
// Animation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that defines the core animation interface for Ignite.
///
/// The `Animation` protocol provides the foundation for creating custom animations with support for
/// duration, timing, delays, and repetition. It works in conjunction with `Animatable` to enable
/// both simple and complex animations through a declarative API.
///
/// Example usage:
/// ```swift
/// struct PulseAnimation: Animation {
///     var body: some Animation {
///         BasicAnimation(.transform, from: "scale(1)", to: "scale(1.1)")
///             .duration(0.5)
///             .timing(.easeInOut)
///             .repeatCount(2, autoreverses: true)
///     }
/// }
/// ```
public protocol Animation {
    associatedtype Body: Animation
    var body: Body { get }
    var name: String { get }
    static var id: String { get }
    
    func duration(_ duration: Double) -> Self
    func timing(_ function: AnimationCurve) -> Self
    func delay(_ delay: Double) -> Self
    func repeatCount(_ count: Double, autoreverses: Bool) -> Self
    func speed(_ speed: Double) -> Self
}

public extension Animation {
    /// A unique identifier generated from the animation type name
    static var id: String {
        String(describing: self).truncatedHash
    }
    
    /// A kebab-case name combining the type name and unique identifier
    var name: String {
        let typeName = String(describing: type(of: self))
            .replacing(#/Animation/#, with: "")
        let kebabCase = typeName.kebabCased()
        return "\(kebabCase)-\(UUID().uuidString.truncatedHash)"
    }
}

public extension Animation {
    func speed(_ speed: Double) -> Self { self }
    func duration(_ duration: Double) -> Self { self }
    func timing(_ function: AnimationCurve) -> Self { self }
    func delay(_ delay: Double) -> Self { self }
    func repeatCount(_ count: Double, autoreverses: Bool = true) -> Self { self }
}

public extension Animation where Self: Animatable {
    /// Adjusts the animation speed by modifying its duration.
    /// - Parameter speed: The speed multiplier. Values greater than 1 increase speed, less than 1 decrease it.
    func speed(_ speed: Double) -> Self {
        duration(self.duration / speed)
    }
    
    /// Sets the animation duration.
    /// - Parameter duration: The duration in seconds.
    func duration(_ duration: Double) -> Self {
        var copy = self
        copy.duration = duration
        return copy
    }
    
    /// Sets the animation timing function.
    /// - Parameter function: The timing curve to use.
    func timing(_ function: AnimationCurve) -> Self {
        var copy = self
        copy.timing = function
        return copy
    }
    
    /// Sets a delay before the animation begins.
    /// - Parameter delay: The delay duration in seconds.
    func delay(_ delay: Double) -> Self {
        var copy = self
        copy.delay = delay
        return copy
    }
    
    /// Configures animation repetition.
    /// - Parameters:
    ///   - count: Number of times to repeat. Use `.infinity` for endless repetition.
    ///   - autoreverses: Whether the animation should play in reverse after completing.
    func repeatCount(_ count: Double, autoreverses: Bool = true) -> Self {
        var copy = self
        copy.repeatCount = count
        copy.autoreverses = autoreverses
        return copy
    }
}

public extension Animation {
    @MainActor func register(for elementID: String) -> String {
        if let resolvedAnimation = AnimationBuilder.buildBlock(self) as? ResolvedAnimation ??
            AnimationBuilder.buildBlock(body) as? ResolvedAnimation
        {
            AnimationManager.shared.registerAnimation(resolvedAnimation, for: elementID)
            return resolvedAnimation.name
        }
        return ""
    }
}

public extension Animation where Self == BasicAnimation {
    /// Creates a fade-in animation that transitions opacity from 0 to 1.
    static var fadeIn: BasicAnimation {
        BasicAnimation(.opacity, from: "0", to: "1")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a fade-out animation that transitions opacity from 1 to 0.
    static var fadeOut: BasicAnimation {
        BasicAnimation(.opacity, from: "1", to: "0")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates an animation that slides content in from a specified edge.
    static func slideIn(from edge: Edge) -> BasicAnimation {
        let (property, from) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return BasicAnimation(.opacity, from: "\(property)(\(from))", to: "\(property)(0)")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates an animation that slides content out to a specified edge.
    static func slideOut(to edge: Edge) -> BasicAnimation {
        let (property, to) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return BasicAnimation(.opacity, from: "\(property)(0)", to: "\(property)(\(to))")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a rotation animation by specified degrees.
    static func rotate(degrees: Double, anchor: AnchorPoint = .center) -> BasicAnimation {
        BasicAnimation(.transform, from: "rotate(0deg)", to: "rotate(\(degrees)deg)")
            .baseProperty(.init(name: .transformOrigin, value: anchor.value))
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a scale animation between two values.
    static func scale(from: Double = 0.8, to: Double = 1.0) -> BasicAnimation {
        BasicAnimation(.transform, from: "scale(\(from))", to: "scale(\(to))")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a color transition animation.
    static func color(from: String, to: String) -> BasicAnimation {
        BasicAnimation(.color, from: from, to: to)
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a background color transition animation.
    static func backgroundColor(from: String, to: String) -> BasicAnimation {
        BasicAnimation(.backgroundColor, from: from, to: to)
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a blur effect animation.
    static func blur(radius: Double) -> BasicAnimation {
        BasicAnimation(.filter, from: "blur(0px)", to: "blur(\(radius)px)")
            .duration(0.35)
            .timing(.automatic)
    }
    
    /// Creates a bouncing animation.
    static var bounce: BasicAnimation {
        BasicAnimation(.transform, from: "translateY(0)", to: "translateY(-20px)")
            .duration(0.5)
            .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
            .repeatCount(1, autoreverses: true)
    }
    
    /// Creates a shaking animation.
    static var wiggle: BasicAnimation {
        BasicAnimation(.transform, from: "translateX(0)", to: "translateX(10px)")
            .duration(0.5)
            .timing(.automatic)
            .repeatCount(3, autoreverses: true)
    }
    
    /// Creates a 3D flip animation in the specified direction.
    /// - Parameter direction: The direction to flip (.forward, .backward, .up, .down)
    /// - Returns: A configured BasicAnimation for 3D flipping
    static func flip(_ direction: Rotation = .forward) -> BasicAnimation {
        let (axis, degrees) = switch direction {
        case .forward: ("Y", "360deg")
        case .backward: ("Y", "-360deg")
        case .up: ("X", "-360deg")
        case .down: ("X", "360deg")
        }
        
        return BasicAnimation(
            .transform,
            from: "perspective(400px) rotate\(axis)(0)",
            to: "perspective(400px) rotate\(axis)(\(degrees))"
        )
        .duration(0.5)
        .timing(.easeInOut)
    }
}