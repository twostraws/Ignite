//
// Analytics.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Analytics` snippet generation.
@Suite("Analytics Tests")
@MainActor
struct AnalyticsTests {
    @Test("Google Analytics produces correct script")
    func googleAnalytics() {
        let analytics = Analytics(.googleAnalytics(measurementID: "GA-12345"))
        let output = analytics.googleAnalyticsCode(for: "GA-12345")

        #expect(output == """
        <!-- Google Analytics 4 -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=GA-12345"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'GA-12345');
        </script>
        """)
    }

    @Test("Fathom produces correct script")
    func fathom() {
        let analytics = Analytics(.fathom(siteID: "ABCDE"))
        let output = analytics.fathomCode(for: "ABCDE")

        #expect(output == """
        <!-- Fathom Analytics -->
        <script src="https://cdn.usefathom.com/script.js" data-site="ABCDE" defer></script>
        """)
    }

    @Test("Clicky produces correct script")
    func clicky() {
        let analytics = Analytics(.clicky(siteID: "12345"))
        let output = analytics.clickyCode(for: "12345")

        #expect(output == """
        <!-- Clicky Analytics -->
        <script>var clicky_site_ids = clicky_site_ids || []; clicky_site_ids.push(12345);</script>
        <script async src="//static.getclicky.com/js"></script>
        """)
    }

    @Test("TelemetryDeck produces correct script")
    func telemetryDeck() {
        let analytics = Analytics(.telemetryDeck(siteID: "ABC-123"))
        let output = analytics.telemetryDeckCode(for: "ABC-123")

        #expect(output == """
        <!-- TelemetryDeck Analytics -->
        <script
            src="https://cdn.telemetrydeck.com/websdk/telemetrydeck.min.js"
            data-app-id="ABC-123"
        ></script>
        """)
    }

    @Test("Plausible with no measurements produces base script")
    func plausibleNoMeasurements() {
        let analytics = Analytics(.plausible(domain: "example.com"))
        let output = analytics.plausibleCode(for: "example.com", using: [])

        #expect(output == """
        <!-- Plausible Analytics -->
        <script defer data-domain="example.com" src="https://plausible.io/js/script.js"></script>
        """)
    }

    @Test("Plausible with single measurement includes it in URL")
    func plausibleSingleMeasurement() {
        let analytics = Analytics(.plausible(domain: "example.com", measurements: [.hash]))
        let output = analytics.plausibleCode(for: "example.com", using: [.hash])

        #expect(output == """
        <!-- Plausible Analytics -->
        <script defer data-domain="example.com" src="https://plausible.io/js/script.hash.js"></script>
        """)
    }

    @Test("Plausible with multiple measurements sorts them alphabetically")
    func plausibleMultipleMeasurementsSorted() {
        let measurements: Set<Analytics.PlausibleMeasurement> = [.outboundLinks, .hash]
        let analytics = Analytics(.plausible(domain: "example.com", measurements: measurements))
        let output = analytics.plausibleCode(for: "example.com", using: measurements)

        #expect(output == """
        <!-- Plausible Analytics -->
        <script defer data-domain="example.com" src="https://plausible.io/js/script.hash.outbound-links.js"></script>
        """)
    }

    @Test("Plausible with track404 adds separate script block")
    func plausibleTrack404() {
        let measurements: Set<Analytics.PlausibleMeasurement> = [.track404]
        let analytics = Analytics(.plausible(domain: "example.com", measurements: measurements))
        let output = analytics.plausibleCode(for: "example.com", using: measurements)

        #expect(output.contains("src=\"https://plausible.io/js/script.js\""))
        #expect(output.contains("window.plausible = window.plausible || function()"))
        #expect(output.contains("window.plausible.q"))
    }

    @Test("Plausible with track404 and other measurements combines correctly")
    func plausibleTrack404WithOtherMeasurements() {
        let measurements: Set<Analytics.PlausibleMeasurement> = [.track404, .hash, .revenue]
        let analytics = Analytics(.plausible(domain: "example.com", measurements: measurements))
        let output = analytics.plausibleCode(for: "example.com", using: measurements)

        #expect(output.contains("src=\"https://plausible.io/js/script.hash.revenue.js\""))
        #expect(output.contains("window.plausible = window.plausible || function()"))
    }

    @Test("Plausible all measurements produce deterministic order")
    func plausibleAllMeasurementsSorted() {
        let all: Set<Analytics.PlausibleMeasurement> = [
            .fileDownloads, .hash, .outboundLinks,
            .pageviewProps, .revenue, .taggedEvents
        ]
        let analytics = Analytics(.plausible(domain: "example.com", measurements: all))
        let output = analytics.plausibleCode(for: "example.com", using: all)

        let expected = "script.file-downloads.hash.outbound-links.pageview-props.revenue.tagged-events.js"
        #expect(output.contains(expected))
    }
}
