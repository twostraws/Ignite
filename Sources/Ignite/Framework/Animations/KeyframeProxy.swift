//
// Keyframe.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public struct KeyframeProxy {
    public func callAsFunction(_ position: Percentage) -> Keyframe {
        Keyframe(position)
    }
}
