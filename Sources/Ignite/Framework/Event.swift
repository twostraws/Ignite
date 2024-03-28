//
// Event.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One event that can trigger a series of actions, such as
/// an onClick event hiding an element on the page.
struct Event {
    var name: String
    var actions: [Action]
}
