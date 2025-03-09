//
// DisplayModeQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on the web application's display mode.
public enum DisplayModeQuery: String, Query, CaseIterable {
    /// Standard browser mode
    case browser = "display-mode: browser"
    /// Full screen mode
    case fullscreen = "display-mode: fullscreen"
    /// Minimal UI mode
    case minimalUI = "display-mode: minimal-ui"
    /// Picture-in-picture mode
    case pip = "display-mode: picture-in-picture"
    /// Standalone application mode
    case standalone = "display-mode: standalone"
    /// Window controls overlay mode
    case windowControlsOverlay = "display-mode: window-controls-overlay"

    public var condition: String { rawValue }
}

extension DisplayModeQuery: MediaFeature {
    public var description: String {
        rawValue
    }
}
