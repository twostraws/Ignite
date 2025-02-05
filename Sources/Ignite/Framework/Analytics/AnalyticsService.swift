//
// AnalyticsService.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Analytics {
    /// Defines the different types of analytics services supported
    public enum Service {
        /// Google Analytics 4
        case googleAnalytics(measurementID: String)
        /// Plausible Analytics
        case plausible(domain: String, measurements: Set<PlausibleMeasurement> = [])
        /// Fathom Analytics
        case fathom(siteID: String)
        /// Clicky Analytics
        case clicky(siteID: String)
        /// TelemetryDeck Analytics
        case telemetryDeck(siteID: String)
        /// Custom analytics script
        case custom(_ code: String)
    }
}
