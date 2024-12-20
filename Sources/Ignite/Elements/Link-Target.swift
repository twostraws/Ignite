//
// Link-Target.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Link {
    /// Controls where this link should be opened, e.g. in the current browser
    /// window or in a new window.
    public enum Target {
        /// No location is specified, which usually means the link opens in
        /// the current browser window.
        case `default`

        /// The page should be opened in a new window.
        case blank

        /// The page should be opened in a new window. (same as `.blank`)`
        case newWindow

        /// The page should be opened in the parent window.
        case parent

        /// The page should be opened at the top-most level in the user's
        /// browser. Used when your page is displayed inside a frame.
        case top

        /// Target a specific, named location.
        case custom(String)

        /// Converts enum cases to the matching HTML.
        var name: String? {
            switch self {
            case .default:
                nil
            case .blank, .newWindow:
                "_blank"
            case .parent:
                "_parent"
            case .top:
                "_top"
            case .custom(let name):
                name
            }
        }
    }
}
