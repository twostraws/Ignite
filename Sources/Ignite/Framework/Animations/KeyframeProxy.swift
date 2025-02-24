//
// Keyframe.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A proxy type that enables a function-like syntax for creating keyframes.
public struct KeyframeProxy {
    public func callAsFunction(_ position: Percentage) -> Keyframe {
        Keyframe(position)
    }
}
