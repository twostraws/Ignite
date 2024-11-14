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
    let frames: [Frame]
    
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
        frames: [Frame] = [],
        trigger: AnimationTrigger = .hover,
        duration: Double = 0.35,
        timing: AnimationCurve = AnimationCurve.easeOut,
        delay: Double = 0,
        repeatCount: Double? = nil,
        autoreverses: Bool = false
    ) {
        self.name = name ?? "animation-\(Self.id)"
        self.frames = frames
        self.trigger = trigger
        self.duration = duration
        self.timing = timing
        self.delay = delay
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
    }
    
    /// The animation's body, required by the Animation protocol
    var body: some Animation { self }
    
    /// Generates CSS keyframe definitions for this animation.
    /// - Returns: A string containing the CSS @keyframes rules for this animation
    func generateKeyframes() -> String {
        let forward = frames.map { frame in
            """
            \(frame.position) {
                \(frame.animations.map { animation in
                    "\(animation.property): \(animation.to)"
                }.joined(separator: ";\n    "))
            }
            """
        }.joined(separator: "\n    ")
        
        let forwardKeyframes = """
        @keyframes \(name)-\(trigger.rawValue) {
            \(forward)
        }
        """
        
        if trigger == .click {
            let reverse = frames.reversed().map { frame in
                let position = frame.position == "0%" ? "100%" :
                    frame.position == "100%" ? "0%" :
                    frame.position
                return """
                \(position) {
                    \(frame.animations.map { animation in
                        "\(animation.property): \(animation.to)"
                    }.joined(separator: ";\n    "))
                }
                """
            }.joined(separator: "\n    ")
            
            let reverseKeyframes = """
            @keyframes \(name)-\(trigger.rawValue)-reverse {
                \(reverse)
            }
            """
            
            return "\(forwardKeyframes)\n\n\(reverseKeyframes)"
        }
        
        return forwardKeyframes
    }
}
