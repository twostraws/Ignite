//
// AnalyticsPlausibleMeasurement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Analytics {
    /// Defines the available measurement options for Plausible Analytics
    public enum PlausibleMeasurement: String, Hashable, CaseIterable {
        case fileDownloads = "file-downloads"
        case hash
        case outboundLinks = "outbound-links"
        case pageviewProps = "pageview-props"
        case revenue
        case taggedEvents = "tagged-events"
        case track404 = "404"
    }
}
