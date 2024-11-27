//
//  CornerRadii.swift
//  Ignite
//
//  Created by Joshua Toro on 11/4/24.
//

import Foundation

/// Represents the corner radii for an HTML element, allowing different radius values for each corner.
public struct CornerRadii {
    /// The radius of the top-leading corner.
    public var topLeading: Int
    
    /// The radius of the top-trailing corner.
    public var topTrailing: Int
    
    /// The radius of the bottom-leading corner.
    public var bottomLeading: Int
    
    /// The radius of the bottom-trailing corner.
    public var bottomTrailing: Int
    
    /// Creates a new `CornerRadii` instance with the specified radii.
    /// - Parameters:
    ///   - topLeading: The radius of the top-leading corner in pixels.
    ///   - topTrailing: The radius of the top-trailing corner in pixels.
    ///   - bottomLeading: The radius of the bottom-leading corner in pixels.
    ///   - bottomTrailing: The radius of the bottom-trailing corner in pixels.
    public init(
        topLeading: Int = 0,
        topTrailing: Int = 0,
        bottomLeading: Int = 0,
        bottomTrailing: Int = 0
    ) {
        self.topLeading = topLeading
        self.topTrailing = topTrailing
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
    }
    
    /// Creates a new `CornerRadii` instance with the same radius applied to all corners.
    /// - Parameter radius: The radius to apply to all corners in pixels.
    public static func all(_ radius: Int) -> CornerRadii {
        CornerRadii(
            topLeading: radius,
            topTrailing: radius,
            bottomLeading: radius,
            bottomTrailing: radius
        )
    }
}
