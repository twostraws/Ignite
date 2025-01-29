//
// TimeZone-StaticVariables.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension TimeZone {
    static var gmt: TimeZone? { TimeZone(secondsFromGMT: 0) }
}
