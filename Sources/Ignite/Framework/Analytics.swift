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

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

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
        /// Custom analytics script
        case custom(_ code: String)

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

    /// The analytics service to use
    private let service: Service

    /// Creates a new analytics snippet for the specified service
    /// - Parameter service: The analytics service to configure
    public init(_ service: Service) {
        self.service = service
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        switch service {
        case .googleAnalytics(let measurementID):
            return """
            <!-- Google Analytics 4 -->
            <script async src="https://www.googletagmanager.com/gtag/js?id=\(measurementID)"></script>
            <script>
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', '\(measurementID)');
            </script>
            """

        case .plausible(let domain, let measurements):
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
                script + "\n<script>window.plausible = window.plausible || function() { (window.plausible.q = window.plausible.q || []).push(arguments) }</script>"
            }
            return script

        case .fathom(let siteID):
            return """
            <!-- Fathom Analytics -->
            <script src="https://cdn.usefathom.com/script.js" data-site="\(siteID)" defer></script>
            """

        case .clicky(let siteID):
            return """
            <!-- Clicky Analytics -->
            <script>var clicky_site_ids = clicky_site_ids || []; clicky_site_ids.push(\(siteID));</script>
            <script async src="//static.getclicky.com/js"></script>
            """

        case .custom(let code):
            return code
        }
    }
}
