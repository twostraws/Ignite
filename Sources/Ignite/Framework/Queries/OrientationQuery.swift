//
// OrientationQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on the device orientation.
public enum OrientationQuery: String, Query, CaseIterable {
    /// Portrait orientation
    case portrait = "orientation: portrait"
    /// Landscape orientation
    case landscape = "orientation: landscape"

    public var condition: String { rawValue }
}

extension OrientationQuery: MediaFeature {
    public var description: String {
        rawValue
    }
}
