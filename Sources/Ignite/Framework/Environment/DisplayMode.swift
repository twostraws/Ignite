//
// DisplayMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the current display mode of the web application.
public enum DisplayMode: String, Environment.MediaQueryValue {
    case fullscreen, standalone, minimalUI, browser
    public var key: String { "display-mode" }
    public var query: String { "display-mode" }
}
