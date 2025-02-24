//
// KeyframeBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that enables a declarative syntax for creating keyframe animations.
@resultBuilder
public struct KeyframeBuilder {
    /// Combines multiple keyframes into an array.
    public static func buildBlock(_ components: Keyframe...) -> [Keyframe] {
        components
    }

    /// Converts a single keyframe into its base type.
    public static func buildExpression(_ expression: Keyframe) -> Keyframe {
        expression
    }

    /// Handles optional keyframes by providing nil as fallback.
    public static func buildOptional(_ component: Keyframe?) -> Keyframe? {
        component
    }

    /// Handles conditional keyframes by returning the first branch.
    public static func buildEither(first component: Keyframe) -> Keyframe {
        component
    }

    /// Handles conditional keyframes by returning the second branch.
    public static func buildEither(second component: Keyframe) -> Keyframe {
        component
    }
}
