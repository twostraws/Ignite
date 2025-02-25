//
// Padding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension AnimationClassGenerator {
    /// Generates the base CSS properties for a keyframe animation
    /// - Parameter animation: The keyframe animation to process
    /// - Returns: A set of CSS properties including animation name and timing
    func buildBaseKeyframeClass(_ animation: Animation) -> Set<String> {
        var baseProperties = Set<String>()
        let baseClass = "animation-" + animation.id
        let timing = getAnimationTiming(animation)
        baseProperties.insert("animation: \(baseClass)-appear \(timing)")
        return baseProperties
    }

    /// Creates CSS classes and keyframe definitions for hover-triggered animations
    /// - Parameter animation: The keyframe animation to convert to CSS
    /// - Returns: A string containing both the CSS class and @keyframes definition
    func buildKeyframeHoverClass(_ animation: Animation) -> String {
        let timing = getAnimationTiming(animation)
        let iterationCount = animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount)

        // Build initial state for .backwards or .both
        let baseState = baseState(for: animation)

        // Build post-hover state for .forwards or .both
        let postHoverState = if animation.fillMode == .forwards || animation.fillMode == .both {
            animation.frames.first?.styles
                .map { "\($0.property): \($0.value)" }
                .joined(separator: ";\n            ")
        } else {
            ""
        }

        // Add fill mode class if needed
        let fillModeClass = fillMode(for: animation, timing: timing, iterations: iterationCount)

        let animationRepeat = animation.repeatCount != 1 ? " " + iterationCount : ""
        let baseClass = "animation-" + animation.id

        return """
        .\(baseClass)-hover {
            transform-style: preserve-3d;
            \(baseState)
        }

        .\(baseClass)-hover:hover {
            animation: \(baseClass)-hover \(timing) \(animation.direction)\(animationRepeat);
        }

        .\(baseClass)-hover:not(:hover) {
            \(postHoverState ?? "")
        }
        \(fillModeClass)

        @keyframes \(baseClass)-hover {
            \(buildKeyframeContent(animation))
        }
        """
    }

    /// Generates the keyframe content for an animation by mapping frame properties to CSS keyframe syntax
    /// - Parameter animation: The animation containing frames to convert
    /// - Returns: A string containing the formatted keyframe rules
    func buildKeyframeContent(_ animation: Animation) -> String {
        animation.frames.map { frame in
            let properties = frame.styles
                .map { "\($0.property): \($0.value)" }
                .joined(separator: ";\n                ")

            return """
                    \(frame.position.roundedValue.asString()) {
                        \(properties)
                    }
            """
        }.joined(separator: "\n        ")
    }

    /// Creates CSS classes for click-triggered keyframe animations, handling transform and
    /// non-transform properties separately.
    /// - Parameter animation: The keyframe animation to convert to CSS.
    /// - Returns: A string containing the CSS classes for clicked and unclicked states.
    func buildKeyframeClickClass(_ animation: Animation) -> String {
        guard let firstFrame = animation.frames.first,
              let lastFrame = animation.frames.last else { return "" }

        var properties = ClickAnimationProperties()
        let timing = getAnimationTiming(animation)

        // Build common animation properties
        var animationProperties = [
            "animation-fill-mode: \(animation.fillMode)",
            "animation-direction: \(animation.direction)"
        ]

        if animation.repeatCount != 1 {
            let animationIteration = animation.repeatCount == .infinity ? "infinite" : String(animation.repeatCount)
            animationProperties.append("animation-iteration-count: \(animationIteration)")
        }

        // Add transitions for all unique properties
        let allProperties = Set(animation.frames.flatMap { frame in
            frame.styles.map(\.property)
        })

        for property in allProperties {
            if property == "transform" {
                properties.transformTransitions.append("\(property) \(timing)")
            } else {
                properties.nonTransformTransitions.append("\(property) \(timing)")
            }
        }

        // Add final values from last frame
        for anim in lastFrame.styles {
            if anim.property == "transform" {
                properties.transformProperties.append("\(anim.property): \(anim.value)")
            } else {
                properties.nonTransformProperties.append("\(anim.property): \(anim.value)")
            }
        }

        // Add initial values from first frame
        for anim in firstFrame.styles {
            if anim.property == "transform" {
                properties.unclickedTransformProperties.append("\(anim.property): \(anim.value)")
            } else {
                properties.unclickedNonTransformProperties.append("\(anim.property): \(anim.value)")
            }
        }

        return buildClickOutput(properties, id: animation.id)
    }

    private func baseState(for animation: Animation) -> String {
        if animation.fillMode == .backwards || animation.fillMode == .both {
            animation.frames.last?.styles
                .map { "\($0.property): \($0.value)" }
                .joined(separator: ";\n            ") ?? ""
        } else if animation.fillMode == .forwards || animation.fillMode == .both {
            animation.frames.first?.styles
                .map { "\($0.property): \($0.value)" }
                .joined(separator: ";\n            ") ?? ""
        } else {
            ""
        }
    }

    private func fillMode(for animation: Animation, timing: String, iterations: String) -> String {
        if animation.fillMode == .backwards || animation.fillMode == .both {
            let count = animation.repeatCount != 1 ? " " + iterations : ""
            let baseClass = "animation-" + animation.id
            return """

            .\(baseClass)-hover.fill-\(animation.id)-\(animation.fillMode) {
                animation: \(baseClass)-hover \(timing) \(animation.direction) \(animation.fillMode)\(count);
                animation-play-state: paused;
            }

            .\(baseClass)-hover.fill-\(animation.id)-\(animation.fillMode):hover {
                animation-play-state: running;
            }
            """
        } else {
            return ""
        }
    }
}
