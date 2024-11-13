//
// Animation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The main animation configuration type that provides a flexible way to define CSS animations
public struct Animation: Animatable, Hashable {
    /// The duration of the animation in seconds
    public var duration: Double
    /// The CSS timing function string that defines the animation's acceleration curve
    public var cssTimingFunction: String
    /// The delay before the animation starts in seconds
    public var delay: Double = 0
    /// The number of times to repeat the animation
    public var repeatCount: Double?
    /// Whether the animation should reverse direction on alternate cycles
    public var autoreverses: Bool = false
    /// The CSS properties being animated and their values
    public var properties: [AnimationValue] = []
    
    /// Defines the available timing functions for animations
    public enum TimingFunction {
        /// Linear timing with constant speed
        case linear
        /// Starts slow, then speeds up
        case easeIn
        /// Starts fast, then slows down
        case easeOut
        /// Starts slow, speeds up in the middle, then slows down
        case easeInOut
        /// Spring-like animation with customizable damping and velocity
        case spring(dampingRatio: Double, velocity: Double)
        
        var cssValue: String {
            switch self {
            case .linear: return "linear"
            case .easeIn: return "ease-in"
            case .easeOut: return "ease-out"
            case .easeInOut: return "ease-in-out"
            case .spring(let damping, let velocity):
                return "cubic-bezier(0.4, \(damping), \(velocity), 1.0)"
            }
        }
    }
    
    // MARK: - Protocol Implementation

    /// Adjusts the animation speed by dividing the duration
    public func speed(_ speed: Double) -> Animation {
        duration(duration / speed)
    }
    
    /// Sets the animation duration in seconds
    public func duration(_ duration: Double) -> Animation {
        var copy = self
        copy.duration = duration
        return copy
    }
    
    /// Sets the delay before the animation starts
    public func delay(_ delay: Double) -> Animation {
        var copy = self
        copy.delay = delay
        return copy
    }
    
    /// Makes the animation repeat indefinitely
    public func repeatForever(autoreverses: Bool = true) -> Animation {
        var copy = self
        copy.repeatCount = .infinity
        copy.autoreverses = autoreverses
        return copy
    }
    
    /// Sets a specific number of times to repeat the animation
    public func repeatCount(_ count: Int, autoreverses: Bool = true) -> Animation {
        var copy = self
        copy.repeatCount = Double(count)
        copy.autoreverses = autoreverses
        return copy
    }
    
    /// Sets whether the animation should reverse on alternate cycles
    public func autoReverse(_ autoreverses: Bool = true) -> Animation {
        var copy = self
        copy.autoreverses = autoreverses
        return copy
    }
}
    
public extension Animation {
    /// Creates a linear timing animation
    static var linear: Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.linear.cssValue,
            delay: 0,
            repeatCount: nil,
            autoreverses: false
        )
    }
    
    /// Creates a linear timing animation with specified duration
    static func linear(duration: Double) -> Animation {
        linear.duration(duration)
    }
    
    /// Creates an ease-in timing animation
    static var easeIn: Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeIn.cssValue,
            delay: 0,
            repeatCount: nil,
            autoreverses: false
        )
    }
    
    /// Creates an ease-in timing animation with specified duration
    static func easeIn(duration: Double) -> Animation {
        easeIn.duration(duration)
    }
    
    /// Creates an ease-out timing animation
    static var easeOut: Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            delay: 0,
            repeatCount: nil,
            autoreverses: false
        )
    }
    
    /// Creates an ease-out timing animation with specified duration
    static func easeOut(duration: Double) -> Animation {
        easeOut.duration(duration)
    }
    
    /// Creates an ease-in-out timing animation
    static var easeInOut: Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            delay: 0,
            repeatCount: nil,
            autoreverses: false
        )
    }
    
    /// Creates an ease-in-out timing animation with specified duration
    static func easeInOut(duration: Double) -> Animation {
        easeInOut.duration(duration)
    }
    
    /// Creates a spring timing animation with customizable parameters
    static func spring(dampingRatio: Double = 0.5, velocity: Double = 0.0) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.spring(dampingRatio: dampingRatio, velocity: velocity).cssValue,
            delay: 0,
            repeatCount: nil,
            autoreverses: false
        )
    }
}

// MARK: - Predefined Animations

public extension Animation {
    /// Creates a fade-in animation
    static func fadeIn() -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            properties: [
                AnimationValue(name: "opacity", initial: "0", final: "1")
            ]
        )
    }
    
    /// Creates a fade-out animation
    static func fadeOut() -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            properties: [
                AnimationValue(name: "opacity", initial: "1", final: "0")
            ]
        )
    }
    
    /// Creates a slide-in animation from a specified edge
    static func slideIn(from edge: Edge) -> Animation {
        let (property, from) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "\(property)(\(from))",
                    final: "\(property)(0)"
                )
            ]
        )
    }
    
    /// Creates a slide-out animation to a specified edge
    static func slideOut(to edge: Edge) -> Animation {
        let (property, to) = switch edge {
        case .leading: ("translateX", "-100%")
        case .trailing: ("translateX", "100%")
        case .top: ("translateY", "-100%")
        case .bottom: ("translateY", "100%")
        default: ("translateX", "-100%")
        }
        
        return Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "\(property)(0)",
                    final: "\(property)(\(to))"
                )
            ]
        )
    }
    
    /// Creates a rotation animation by specified degrees
    static func rotate(degrees: Double) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeOut.cssValue,
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "rotate(0deg)",
                    final: "rotate(\(degrees)deg)"
                )
            ]
        )
    }
    
    /// Creates a scale animation between two values
    static func scale(from: Double = 0.8, to: Double = 1.0) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.spring(dampingRatio: 0.5, velocity: 0.1).cssValue,
            properties: [
                AnimationValue(name: "transform", initial: "scale(\(from))", final: "scale(\(to))")
            ]
        )
    }
    
    /// Creates a color transition animation
    static func color(from: String, to: String) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            properties: [
                AnimationValue(
                    name: "color",
                    initial: from,
                    final: to
                )
            ]
        )
    }
    
    /// Creates a background color transition animation
    static func backgroundColor(from: String, to: String) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            properties: [
                AnimationValue(
                    name: "background-color",
                    initial: from,
                    final: to
                )
            ]
        )
    }
    
    /// Creates a size transition animation
    static func size(width: String? = nil, height: String? = nil) -> Animation {
        var properties: [AnimationValue] = []
        
        if let width {
            properties.append(AnimationValue(name: "width", initial: "auto", final: width))
        }
        if let height {
            properties.append(AnimationValue(name: "height", initial: "auto", final: height))
        }
        
        return Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            properties: properties
        )
    }
    
    /// Creates a blur effect animation
    static func blur(radius: Double) -> Animation {
        Animation(
            duration: 0.35,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            properties: [
                AnimationValue(
                    name: "filter",
                    initial: "blur(0px)",
                    final: "blur(\(radius)px)"
                )
            ]
        )
    }
    
    /// Creates a bouncing animation
    static func bounce() -> Animation {
        Animation(
            duration: 0.5,
            cssTimingFunction: "cubic-bezier(0.36, 0, 0.66, -0.56)",
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "translateY(0)",
                    final: "translateY(-20px)"
                )
            ]
        ).autoReverse()
    }
    
    /// Creates a shaking animation
    static func shake() -> Animation {
        Animation(
            duration: 0.5,
            cssTimingFunction: "ease-in-out",
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "translateX(0)",
                    final: "translateX(10px)"
                )
            ]
        ).repeatCount(3).autoReverse()
    }
    
    /// Creates a flip animation
    static func flip() -> Animation {
        Animation(
            duration: 0.6,
            cssTimingFunction: TimingFunction.easeInOut.cssValue,
            properties: [
                AnimationValue(
                    name: "transform",
                    initial: "perspective(400px) rotateY(0)",
                    final: "perspective(400px) rotateY(180deg)"
                )
            ]
        )
    }
    
    /// Creates a pop-in animation combining scale and fade
    static func popIn() -> Animation {
        Animation(
            duration: 0.4,
            cssTimingFunction: TimingFunction.spring(dampingRatio: 0.5, velocity: 0.1).cssValue,
            properties: [
                AnimationValue(name: "opacity", initial: "0", final: "1"),
                AnimationValue(name: "transform", initial: "scale(0.5)", final: "scale(1)")
            ]
        )
    }
}
