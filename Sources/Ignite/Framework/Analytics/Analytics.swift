//
// AnalyticsSnippet.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Embeds analytics tracking code in the page head section for various analytics services.
public struct Analytics: HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The analytics service to use
    private let service: Service

    /// Creates a new analytics snippet for the specified service
    /// - Parameter service: The analytics service to configure
    public init(_ service: Service) {
        self.service = service
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        switch service {
        case .googleAnalytics(let measurementID):
            googleAnalyticsCode(for: measurementID)

        case .plausible(let domain, let measurements):
            plausibleCode(for: domain, using: measurements)

        case .fathom(let siteID):
            fathomCode(for: siteID)

        case .clicky(let siteID):
            clickyCode(for: siteID)

        case .telemetryDeck(let siteID):
            telemetryDeckCode(for: siteID)

        case .custom(let code):
            code
        }
    }

    /// Creates Clicky analytics code for the current site.
    /// - Parameter siteID: This site's Clicky identifier.
    /// - Returns: HTML for analytics tracking.
    func clickyCode(for siteID: String) -> String {
        """
        <!-- Clicky Analytics -->
        <script>var clicky_site_ids = clicky_site_ids || []; clicky_site_ids.push(\(siteID));</script>
        <script async src="//static.getclicky.com/js"></script>
        """
    }

    /// Creates Fathom analytics code for the current site.
    /// - Parameter siteID: This site's Fathom identifier.
    /// - Returns: HTML for analytics tracking.
    func fathomCode(for siteID: String) -> String {
        """
        <!-- Fathom Analytics -->
        <script src="https://cdn.usefathom.com/script.js" data-site="\(siteID)" defer></script>
        """
    }

    /// Creates Google Analytics code for the current site.
    /// - Parameter measurementID: This site's Google Analytics identifier.
    /// - Returns: HTML for analytics tracking.
    func googleAnalyticsCode(for measurementID: String) -> String {
        """
        <!-- Google Analytics 4 -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=\(measurementID)"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '\(measurementID)');
        </script>
        """
    }

    /// Creates Plausible analytics code for the current site.
    /// - Parameter domain: This site's domain.
    /// - Parameter measurements: The set of items the user is tracking.
    /// - Returns: HTML for analytics tracking.
    func plausibleCode(for domain: String, using measurements: Set<PlausibleMeasurement>) -> String {
        let needs404Script = measurements.contains(.track404)
        let measurements = measurements.filter { $0 != .track404 }
        let measurementString = measurements.isEmpty ? "" : "." + measurements
            .sorted { $0.rawValue < $1.rawValue }
            .map { $0.rawValue }
            .joined(separator: ".")

        var script = """
        <!-- Plausible Analytics -->
        <script defer data-domain="\(domain)" src="https://plausible.io/js/script\(measurementString).js"></script>
        """

        if needs404Script {
            script += """
            \n<script>\
            window.plausible = window.plausible || function() { \
            (window.plausible.q = window.plausible.q || []).push(arguments) \
            }\
            </script>
            """
        }

        return script
    }

    /// Creates TelemetryDeck analytics code for the current site.
    /// - Parameter siteID: This site's TelemetryDeck identifier.
    /// - Returns: HTML for analytics tracking.
    func telemetryDeckCode(for siteID: String) -> String {
        """
        <!-- TelemetryDeck Analytics -->
        <script
            src="https://cdn.telemetrydeck.com/websdk/telemetrydeck.min.js"
            data-app-id="\(siteID)"
        ></script>
        """
    }
}
