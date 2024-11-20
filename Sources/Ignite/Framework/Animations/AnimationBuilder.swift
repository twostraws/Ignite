//
// AnimationBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables a declarative syntax for creating complex animations.
@resultBuilder
public struct AnimationBuilder {
    /// Combines multiple animation values into a single array
    public static func buildBlock(_ components: AnimationData...) -> [AnimationData] {
        components
    }
    
    /// Converts a single animation value into its base type
    public static func buildExpression(_ expression: AnimationData) -> AnimationData {
        expression
    }
    
    /// Handles optional animation values by providing an empty array as fallback
    public static func buildOptional(_ component: [AnimationData]?) -> [AnimationData] {
        component ?? []
    }
    
    /// Handles conditional animation values by returning the first branch
    public static func buildEither(first component: [AnimationData]) -> [AnimationData] {
        component
    }
    
    /// Handles conditional animation values by returning the second branch
    public static func buildEither(second component: [AnimationData]) -> [AnimationData] {
        component
    }
}
