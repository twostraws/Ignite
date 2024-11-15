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
///         StandardAnimation(property: "transform", from: "scale(1)", to: "scale(1.1)")
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
            .replacingOccurrences(of: "Style", with: "")
        let kebabCase = typeName.replacingOccurrences(
            of: "([a-z0-9])([A-Z])",
            with: "$1-$2",
            options: .regularExpression
        ).lowercased()
        
        return "\(kebabCase)-\(UUID().uuidString.truncatedHash)"
    }
}

public extension Animation {
    /// Adjusts the animation speed by modifying its duration.
    /// - Parameter speed: The speed multiplier. Values greater than 1 increase speed, less than 1 decrease it.
    func speed(_ speed: Double) -> Self {
        if var copy = self as? any Animatable {
            duration(copy.duration / speed)
            return copy as! Self
        }
        return self
    }
    
    /// Sets the animation duration.
    /// - Parameter duration: The duration in seconds.
    func duration(_ duration: Double) -> Self {
        if var copy = self as? any Animatable {
            copy.duration = duration
            return copy as! Self
        }
        return self
    }
    
    /// Sets the animation timing function.
    /// - Parameter function: The timing curve to use.
    func timing(_ function: AnimationCurve) -> Self {
        if var copy = self as? any Animatable {
            copy.timing = function
            return copy as! Self
        }
        return self
    }
    
    /// Sets a delay before the animation begins.
    /// - Parameter delay: The delay duration in seconds.
    func delay(_ delay: Double) -> Self {
        if var copy = self as? any Animatable {
            copy.delay = delay
            return copy as! Self
        }
        return self
    }
    
    /// Configures animation repetition.
    /// - Parameters:
    ///   - count: Number of times to repeat. Use `.infinity` for endless repetition.
    ///   - autoreverses: Whether the animation should play in reverse after completing.
    func repeatCount(_ count: Double, autoreverses: Bool = true) -> Self {
        if var copy = self as? any Animatable {
            copy.repeatCount = count
            copy.autoreverses = autoreverses
            return copy as! Self
        }
        return self
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

public extension Animation where Self == StandardAnimation {
    /// Creates a fade-in animation that transitions opacity from 0 to 1.
    static func fadeIn() -> StandardAnimation {
        StandardAnimation(property: "opacity", from: "0", to: "1")
            .duration(0.35)
            .timing(.easeOut)
    }
    
    /// Creates a fade-out animation that transitions opacity from 1 to 0.
    static func fadeOut() -> StandardAnimation {
        StandardAnimation(property: "opacity", from: "1", to: "0")
            .duration(0.35)
            .timing(.easeOut)
    }
    
    /// Creates an animation that slides content in from a specified edge.
    static func slideIn(from edge: Edge) -> StandardAnimation {
        let (property, from) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return StandardAnimation(property: "transform", from: "\(property)(\(from))", to: "\(property)(0)")
            .duration(0.35)
            .timing(.easeOut)
    }
    
    /// Creates an animation that slides content out to a specified edge.
    static func slideOut(to edge: Edge) -> StandardAnimation {
        let (property, to) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return StandardAnimation(property: "transform", from: "\(property)(0)", to: "\(property)(\(to))")
            .duration(0.35)
            .timing(.easeOut)
    }
    
    /// Creates a rotation animation by specified degrees.
    static func rotate(degrees: Double) -> StandardAnimation {
        StandardAnimation(property: "transform", from: "rotate(0deg)", to: "rotate(\(degrees)deg)")
            .duration(0.35)
            .timing(.easeOut)
    }
    
    /// Creates a scale animation between two values.
    static func scale(from: Double = 0.8, to: Double = 1.0) -> StandardAnimation {
        StandardAnimation(property: "transform", from: "scale(\(from))", to: "scale(\(to))")
            .duration(0.35)
            .timing(.spring(dampingRatio: 0.5, velocity: 0.1))
    }
    
    /// Creates a color transition animation.
    static func color(from: String, to: String) -> StandardAnimation {
        StandardAnimation(property: "color", from: from, to: to)
            .duration(0.35)
            .timing(.easeInOut)
    }
    
    /// Creates a background color transition animation.
    static func backgroundColor(from: String, to: String) -> StandardAnimation {
        StandardAnimation(property: "background-color", from: from, to: to)
            .duration(0.35)
            .timing(.easeInOut)
    }
    
    /// Creates a blur effect animation.
    static func blur(radius: Double) -> StandardAnimation {
        StandardAnimation(property: "filter", from: "blur(0px)", to: "blur(\(radius)px)")
            .duration(0.35)
            .timing(.easeInOut)
    }
    
    /// Creates a bouncing animation.
    static func bounce() -> StandardAnimation {
        StandardAnimation(property: "transform", from: "translateY(0)", to: "translateY(-20px)")
            .duration(0.5)
            .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
            .repeatCount(1, autoreverses: true)
    }
    
    /// Creates a shaking animation.
    static func shake() -> StandardAnimation {
        StandardAnimation(property: "transform", from: "translateX(0)", to: "translateX(10px)")
            .duration(0.5)
            .timing(.easeInOut)
            .repeatCount(3, autoreverses: true)
    }
    
    /// Creates a 3D flip animation.
    static func flip() -> StandardAnimation {
        StandardAnimation(
            property: "transform",
            from: "perspective(400px) rotateY(0)",
            to: "perspective(400px) rotateY(360deg)"
        )
        .duration(1.5)
        .timing(.easeInOut)
    }
}
