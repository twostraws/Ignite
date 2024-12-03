//
// DisplayMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents how the web application is being displayed.
public enum DisplayMode: String, QueryType {
    /// Application runs in full-screen mode without browser chrome.
    case fullscreen
    
    /// Application runs as a standalone app with minimal UI.
    case standalone
    
    /// Application runs with a minimal browser interface.
    case minimalUI
    
    /// Application runs in a standard browser window.
    case browser
    
    /// The media query key used in CSS selectors.
    public var key: String { "display-mode" }
    
    /// The complete media query string for detecting display mode.
    public var query: String { "display-mode" }
}

public extension QueryType where Self == DisplayMode {
    /// Creates a display mode query with the specified mode
    /// - Parameter mode: The display mode to query for
    /// - Returns: A DisplayMode query instance
    static func displayMode(_ mode: DisplayMode) -> DisplayMode {
        mode
    }
}
