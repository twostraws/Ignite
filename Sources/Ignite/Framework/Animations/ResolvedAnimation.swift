//
// ResolvedAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A concrete animation type that represents a fully resolved animation ready for CSS generation.
///
/// `ResolvedAnimation` is the final form of all animations in Ignite, containing all necessary
/// information to generate CSS keyframes and animation properties. It serves as the bridge
/// between Ignite's animation DSL and CSS output.
struct ResolvedAnimation: Animation, Animatable {
    /// The unique identifier used for CSS class and keyframe names
    var name: String
    
    /// The collection of keyframes that define this animation's timeline
    var frames: [AnimationFrame]
    
    /// The number of times the animation should repeat
    /// When set to `.infinity`, the animation will loop indefinitely
    var repeatCount: Double?
    
    /// The time to wait before starting the animation, in seconds
    var delay: Double
    
    /// The easing function to use for the animation
    var timing: AnimationCurve
    
    /// The total duration of the animation in seconds
    var duration: Double
    
    /// The event that triggers this animation (hover, click, or appear)
    var trigger: AnimationTrigger
    
    /// Whether the animation should play in reverse after completing
    var autoreverses: Bool
    
    /// Whether this animation was created from a KeyframeAnimation
    var belongsToKeyframeSequence: Bool
    
    /// Static properties that should be applied to the base class
    var staticProperties: [AttributeValue] = []
    
    /// Creates a new resolved animation with the specified parameters.
    /// - Parameters:
    ///   - name: The unique identifier for this animation. If nil, a unique name will be generated
    ///   - frames: The keyframes that define the animation sequence
    ///   - trigger: The event that starts the animation
    ///   - duration: The length of the animation in seconds
    ///   - timing: The easing function to use
    ///   - delay: The time to wait before starting the animation
    ///   - repeatCount: The number of times to repeat the animation
    ///   - autoreverses: Whether the animation should play in reverse after completing
    init(
        name: String? = nil,
        frames: [AnimationFrame] = [],
        trigger: AnimationTrigger = .hover,
        duration: Double = 0.35,
        timing: AnimationCurve = AnimationCurve.easeOut,
        delay: Double = 0,
        repeatCount: Double? = nil,
        autoreverses: Bool = false,
        staticProperties: [AttributeValue] = [],
        isKeyframe: Bool = false
    ) {
        self.name = name ?? "animation-\(Self.id)"
        self.frames = frames
        self.trigger = trigger
        self.duration = duration
        self.timing = timing
        self.delay = delay
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
        self.belongsToKeyframeSequence = isKeyframe
        self.staticProperties = staticProperties
    }
    
    /// The animation's body, required by the Animation protocol
    var body: some Animation { self }
    
    /// Generates CSS keyframe definitions for this animation.
    /// - Returns: A string containing the CSS @keyframes rules for this animation
    func generateKeyframes() -> String {
        let forward = frames.map { frame in
            let properties = frame.animations.map { animation in
                // For KeyframeAnimation frames, use to values
                if belongsToKeyframeSequence {
                    return "\(animation.property.rawValue): \(animation.to)"
                }
                // For BasicAnimation (non-keyframe), use from/to values
                let value = frame.position == 0 ? animation.from : animation.to
                return "\(animation.property.rawValue): \(value)"
            }.joined(separator: ";\n            ")
            
            return """
                \(frame.cssPosition) {
                    \(properties)
                }
            """
        }.joined(separator: "\n    ")
        
        let forwardKeyframes = """
        @keyframes \(name)-\(trigger.rawValue) {
            \(forward)
        }
        """
        
        if trigger == .click && autoreverses {
            let reverse = frames.reversed().map { frame in
                let properties = frame.animations.map { animation in
                    let value = frame.position == 0 ? animation.to : animation.from
                    return "\(animation.property.rawValue): \(value)"
                }.joined(separator: ";\n            ")
                
                return """
                    \(frame.cssPosition) {
                        \(properties)
                    }
                """
            }.joined(separator: "\n    ")
            
            return """
            \(forwardKeyframes)
            
            @keyframes \(name)-\(trigger.rawValue)-reverse {
                \(reverse)
            }
            """
        }
        
        return forwardKeyframes
    }
}
