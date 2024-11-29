//
// FontURL.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that can represent a font family name or URL for use in themes.
public protocol FontURL {}

/// Allows strings to be used as font family names.
extension String: FontURL {}

/// Allows URLs to be used to reference font files.
extension URL: FontURL {}
